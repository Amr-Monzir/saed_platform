from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from app.database.models import User, Volunteer, Organizer
from app.auth.password_utils import get_password_hash
from app.schemas.volunteer import VolunteerCreate
from app.schemas.organizer import OrganizerCreate


class UserService:
    @staticmethod
    def create_volunteer(db: Session, volunteer_data: VolunteerCreate) -> User:
        # Check if user already exists
        if db.query(User).filter(User.email == volunteer_data.email).first():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered",
            )

        # Create user
        hashed_password = get_password_hash(volunteer_data.password)
        user = User(
            email=volunteer_data.email,
            password_hash=hashed_password,
            user_type="volunteer",
        )
        db.add(user)
        db.flush()  # Get the user ID

        # Create volunteer profile
        volunteer = Volunteer(
            user_id=user.id,
            name=volunteer_data.name,
            phone_number=volunteer_data.phone_number,
        )
        db.add(volunteer)

        # Add skills if provided
        if volunteer_data.skill_ids:
            from app.database.models import Skill

            skills = (
                db.query(Skill).filter(Skill.id.in_(volunteer_data.skill_ids)).all()
            )
            volunteer.skills = skills

        db.commit()
        db.refresh(user)
        return user

    @staticmethod
    def get_user_by_email(db: Session, email: str) -> User:
        return db.query(User).filter(User.email == email).first()

    @staticmethod
    def create_organizer(db: Session, organizer_data: OrganizerCreate) -> User:
        # Check if user already exists
        if db.query(User).filter(User.email == organizer_data.email).first():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered",
            )

        # Create user
        hashed_password = get_password_hash(organizer_data.password)
        user = User(
            email=organizer_data.email,
            password_hash=hashed_password,
            user_type="organizer",
        )
        db.add(user)
        db.flush()  # Get the user ID

        # Create organizer profile
        organizer = Organizer(
            user_id=user.id,
            name=organizer_data.name,
            website=organizer_data.website,
            description=organizer_data.description,
        )
        db.add(organizer)

        db.commit()
        db.refresh(user)
        return user
