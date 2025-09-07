from sqlalchemy import (
    Column,
    Integer,
    String,
    DateTime,
    Boolean,
    Text,
    Float,
    ForeignKey,
    Table,
    JSON,
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database.connection import Base
from app.database.enums import (
    validate_enum_value,
    UserType,
    FrequencyType,
    LocationType,
)

# Association tables for many-to-many relationships
volunteer_skills = Table(
    "volunteer_skills",
    Base.metadata,
    Column("volunteer_id", Integer, ForeignKey("volunteers.id"), primary_key=True),
    Column("skill_id", Integer, ForeignKey("skills.id"), primary_key=True),
)

advert_skills = Table(
    "advert_skills",
    Base.metadata,
    Column("advert_id", Integer, ForeignKey("adverts.id"), primary_key=True),
    Column("skill_id", Integer, ForeignKey("skills.id"), primary_key=True),
)


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    password_hash = Column(String, nullable=False)
    user_type = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    volunteer = relationship("Volunteer", back_populates="user", uselist=False)
    organizer = relationship("Organizer", back_populates="user", uselist=False)

    def __init__(self, **kwargs):
        if "user_type" in kwargs:
            kwargs["user_type"] = validate_enum_value(UserType, kwargs["user_type"])
        super().__init__(**kwargs)


class Volunteer(Base):
    __tablename__ = "volunteers"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    name = Column(String, nullable=False)
    phone_number = Column(String)
    onboarding_completed = Column(Boolean, default=False)

    # Relationships
    user = relationship("User", back_populates="volunteer")
    skills = relationship(
        "Skill", secondary=volunteer_skills, back_populates="volunteers"
    )
    applications = relationship("Application", back_populates="volunteer")


class Organizer(Base):
    __tablename__ = "organizers"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    name = Column(String, nullable=False)
    logo_url = Column(String)
    website = Column(String)
    description = Column(Text)

    # Relationships
    user = relationship("User", back_populates="organizer")
    adverts = relationship("Advert", back_populates="organizer")
    created_skills = relationship("Skill", back_populates="created_by_organizer")


class Skill(Base):
    __tablename__ = "skills"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, nullable=False)
    category = Column(String)
    is_predefined = Column(Boolean, default=True)
    created_by = Column(Integer, ForeignKey("organizers.id"), nullable=True)

    # Relationships
    volunteers = relationship(
        "Volunteer", secondary=volunteer_skills, back_populates="skills"
    )
    adverts = relationship(
        "Advert", secondary=advert_skills, back_populates="required_skills"
    )
    created_by_organizer = relationship("Organizer", back_populates="created_skills")


class Advert(Base):
    __tablename__ = "adverts"

    id = Column(Integer, primary_key=True, index=True)
    organizer_id = Column(Integer, ForeignKey("organizers.id"), nullable=False)
    title = Column(String, nullable=False)
    description = Column(Text, nullable=False)
    category = Column(String, nullable=False)
    frequency = Column(String, nullable=False)
    number_of_volunteers = Column(Integer, default=1)
    location_type = Column(String, nullable=False)
    address_text = Column(String)
    postcode = Column(String)
    latitude = Column(Float)
    longitude = Column(Float)
    advert_image_url = Column(String, nullable=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    organizer = relationship("Organizer", back_populates="adverts")
    required_skills = relationship(
        "Skill", secondary=advert_skills, back_populates="adverts"
    )
    oneoff_details = relationship(
        "OneOffAdvert", back_populates="advert", uselist=False
    )
    recurring_details = relationship(
        "RecurringAdvert", back_populates="advert", uselist=False
    )
    applications = relationship("Application", back_populates="advert")

    def __init__(self, **kwargs):
        if "frequency" in kwargs:
            kwargs["frequency"] = validate_enum_value(
                FrequencyType, kwargs["frequency"]
            )
        if "location_type" in kwargs:
            kwargs["location_type"] = validate_enum_value(
                LocationType, kwargs["location_type"]
            )
        super().__init__(**kwargs)


class OneOffAdvert(Base):
    __tablename__ = "oneoff_adverts"

    id = Column(Integer, primary_key=True, index=True)
    advert_id = Column(Integer, ForeignKey("adverts.id"), nullable=False)
    event_datetime = Column(DateTime(timezone=True), nullable=False)
    time_commitment = Column(String, nullable=False)
    application_deadline = Column(DateTime(timezone=True), nullable=False)

    # Relationships
    advert = relationship("Advert", back_populates="oneoff_details")


class RecurringAdvert(Base):
    __tablename__ = "recurring_adverts"

    id = Column(Integer, primary_key=True, index=True)
    advert_id = Column(Integer, ForeignKey("adverts.id"), nullable=False)
    recurrence = Column(String, nullable=False)
    time_commitment_per_session = Column(String, nullable=False)
    duration = Column(String, nullable=False)
    specific_days = Column(JSON)  # [{"day": "monday", "periods": ["am", "pm"]}]

    # Relationships
    advert = relationship("Advert", back_populates="recurring_details")


class Application(Base):
    __tablename__ = "applications"

    id = Column(Integer, primary_key=True, index=True)
    advert_id = Column(Integer, ForeignKey("adverts.id"), nullable=False)
    volunteer_id = Column(Integer, ForeignKey("volunteers.id"), nullable=False)
    status = Column(String, default="pending")
    cover_message = Column(Text, nullable=True)
    organizer_message = Column(Text, nullable=True)
    applied_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    advert = relationship("Advert", back_populates="applications")
    volunteer = relationship("Volunteer", back_populates="applications")
