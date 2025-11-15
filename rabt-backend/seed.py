import random
import os
from datetime import datetime, timedelta
from io import BytesIO

from faker import Faker
from sqlalchemy import create_engine, delete
from sqlalchemy.orm import Session, sessionmaker

from app.auth.password_utils import get_password_hash
from app.config import settings
from app.utils.s3_storage import upload_to_s3
from app.database.enums import (
    DayPeriod,
    DurationType,
    FrequencyType,
    LocationType,
    RecurrenceType,
    TimeCommitment,
    UserType,
)
from app.database.models import (
    Advert,
    Application,
    OneOffAdvert,
    Organizer,
    RecurringAdvert,
    Skill,
    User,
    Volunteer,
    advert_skills,
    volunteer_skills,
)

fake = Faker(locale="en_GB")

SKILLS = [
    "Graphic Design",
    "Social Media Management",
    "Translation",
    "Public Speaking",
    "Event Planning",
    "Photography",
    "Videography",
    "Writing",
    "Research",
    "Legal Knowledge",
    "Medical Training",
    "None Required",
    "Other",
]


def is_database_seeded(db: Session) -> bool:
    """
    Checks if the database has already been seeded by checking if skills exist.
    """
    skill_count = db.query(Skill).count()
    return skill_count > 0


def clear_data(db: Session):
    """
    Clears all data from the database tables in the correct order to avoid FK violations.
    """
    print("Clearing database...")
    # Clear association tables first
    db.execute(delete(volunteer_skills))
    db.execute(delete(advert_skills))
    # Clear tables with dependencies
    db.execute(delete(Application))
    db.execute(delete(OneOffAdvert))
    db.execute(delete(RecurringAdvert))
    db.execute(delete(Advert))
    db.execute(delete(Volunteer))
    db.execute(delete(Organizer))
    db.execute(delete(Skill))
    db.execute(delete(User))
    db.commit()
    print("Database cleared.")


def seed_data():
    """
    Seeds the database with mock data.
    """
    engine = create_engine(settings.database_url, echo=False)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

    with SessionLocal() as db:
        # Check if database is already seeded
        if is_database_seeded(db):
            print("Database is already seeded. Skipping seeding.")
            return
        
        clear_data(db)

        print("Seeding skills...")
        # Create Skills
        for skill_name in SKILLS:
            skill = Skill(name=skill_name, category="General", is_predefined=True)
            db.add(skill)
        db.commit()
        print("Skills seeded.")

        print("Seeding organizers...")
        # Setup for logos
        logo_dir = "seed-data/organizations"
        logo_files = [
            f
            for f in os.listdir(logo_dir)
            if os.path.isfile(os.path.join(logo_dir, f)) and f != ".DS_Store"
        ]

        # Create Organizations
        for i, logo_filename in enumerate(logo_files):
            email = f"organizer{i + 1}@example.com"
            user = User(
                email=email,
                password_hash=get_password_hash(email),
                user_type=UserType.ORGANIZER.value,
            )
            db.add(user)
            db.commit()
            db.refresh(user)

            # Create organizer first
            organizer = Organizer(
                user_id=user.id,
                name=os.path.splitext(logo_filename)[0],
                website=fake.url(),
                description=fake.text(),
                logo_url=None,  # Will be set after upload
            )
            db.add(organizer)
            db.flush()  # Get organizer.id without committing

            # Upload logo to S3 using organizer.id
            logo_path = os.path.join(logo_dir, logo_filename)
            with open(logo_path, "rb") as f:
                # Create a file-like object for upload
                file_obj = BytesIO(f.read())
                # Determine content type from extension
                ext = os.path.splitext(logo_filename)[1].lower()
                content_type_map = {
                    ".png": "image/png",
                    ".jpg": "image/jpeg",
                    ".jpeg": "image/jpeg",
                    ".gif": "image/gif",
                    ".webp": "image/webp"
                }
                content_type = content_type_map.get(ext, "image/png")
                
                # Create a mock UploadFile
                class MockUploadFile:
                    def __init__(self, file_obj, filename, content_type):
                        self.file = file_obj
                        self.filename = filename
                        self.content_type = content_type
                
                mock_file = MockUploadFile(file_obj, logo_filename, content_type)
                logo_url = upload_to_s3(mock_file, "logos", organizer.id)
                organizer.logo_url = logo_url
        db.commit()
        print("Organizers seeded.")

        print("Seeding volunteers...")
        # Create Volunteers
        for i in range(10):
            email = f"volunteer{i + 1}@example.com"
            user = User(
                email=email,
                password_hash=get_password_hash(email),
                user_type=UserType.VOLUNTEER.value,
            )
            db.add(user)
            db.commit()
            db.refresh(user)

            volunteer = Volunteer(
                user_id=user.id,
                name=fake.name(),
                phone_number=fake.phone_number(),
                onboarding_completed=True,
            )
            db.add(volunteer)
        db.commit()
        print("Volunteers seeded.")

        print("Seeding adverts...")
        # Create Adverts
        organizers = db.query(Organizer).all()
        skills = db.query(Skill).all()
        advert_image_dir = "seed-data/adverts"
        advert_image_files = [
            f
            for f in os.listdir(advert_image_dir)
            if os.path.isfile(os.path.join(advert_image_dir, f)) and f != ".DS_Store"
        ]

        for i in range(50):
            organizer = random.choice(organizers)

            advert_image_filename = random.choice(advert_image_files)
            advert_title = os.path.splitext(advert_image_filename)[0]

            # Upload advert image to S3
            advert_image_path = os.path.join(advert_image_dir, advert_image_filename)
            with open(advert_image_path, "rb") as f:
                # Create a file-like object for upload
                file_obj = BytesIO(f.read())
                # Determine content type from extension
                ext = os.path.splitext(advert_image_filename)[1].lower()
                content_type_map = {
                    ".png": "image/png",
                    ".jpg": "image/jpeg",
                    ".jpeg": "image/jpeg",
                    ".gif": "image/gif",
                    ".webp": "image/webp"
                }
                content_type = content_type_map.get(ext, "image/png")
                
                # Create a mock UploadFile
                class MockUploadFile:
                    def __init__(self, file_obj, filename, content_type):
                        self.file = file_obj
                        self.filename = filename
                        self.content_type = content_type
                
                mock_file = MockUploadFile(file_obj, advert_image_filename, content_type)
                # Temporarily add advert_id (will be updated after commit)
                # We'll upload after creating the advert
                temp_file = mock_file

            advert = Advert(
                organizer_id=organizer.id,
                title=advert_title,
                description=fake.text(),
                category=random.choice(["Community", "Environment", "Education"]),
                frequency=random.choice(list(FrequencyType)).value,
                number_of_volunteers=random.randint(1, 10),
                location_type=random.choice(list(LocationType)).value,
                address_text=fake.address(),
                postcode=fake.postcode(),
                is_active=True,
                advert_image_url=None,  # Will be set after upload
                city=fake.city().lower(),
            )

            required_skills = random.sample(skills, k=random.randint(1, 3))
            for skill in required_skills:
                advert.required_skills.append(skill)

            db.add(advert)
            db.flush()
            
            # Now upload the image with the advert ID
            temp_file.file.seek(0)  # Reset file pointer
            advert_image_url = upload_to_s3(temp_file, "adverts", advert.id)
            advert.advert_image_url = advert_image_url

            if advert.frequency == FrequencyType.ONE_OFF.value:
                one_off = OneOffAdvert(
                    advert_id=advert.id,
                    event_datetime=datetime.now()
                    + timedelta(days=random.randint(10, 60)),
                    time_commitment=random.choice(list(TimeCommitment)).value,
                    application_deadline=datetime.now()
                    + timedelta(days=random.randint(1, 9)),
                )
                db.add(one_off)
            else:
                days_of_week = [
                    "monday",
                    "tuesday",
                    "wednesday",
                    "thursday",
                    "friday",
                    "saturday",
                    "sunday",
                ]
                periods = [p.value for p in DayPeriod]
                all_slots = []
                for day in days_of_week:
                    for period in periods:
                        all_slots.append((day, period))

                num_selections = random.randint(12, len(all_slots))
                selected_slots = random.sample(all_slots, num_selections)

                grouped_slots = {}
                for day, period in selected_slots:
                    if day not in grouped_slots:
                        grouped_slots[day] = []
                    grouped_slots[day].append(period)

                specific_days_json = []
                for day, period_list in grouped_slots.items():
                    specific_days_json.append({"day": day, "periods": period_list})

                recurring = RecurringAdvert(
                    advert_id=advert.id,
                    recurrence=random.choice(list(RecurrenceType)).value,
                    time_commitment_per_session=random.choice(
                        list(TimeCommitment)
                    ).value,
                    duration=random.choice(list(DurationType)).value,
                    specific_days=specific_days_json,
                )
                db.add(recurring)

        db.commit()
        print("Adverts seeded.")
        print("Database seeding complete.")


if __name__ == "__main__":
    seed_data()
