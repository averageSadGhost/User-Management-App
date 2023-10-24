from sqlalchemy import Column, Integer, String, DateTime, CheckConstraint, func, text
from sqlalchemy.orm import Session
from datetime import datetime
from .database import Base


class User(Base):
    __tablename__ = 'Users'

    id = Column(Integer, primary_key=True, autoincrement=True)
    email = Column(String, unique=True, nullable=False)
    password = Column(String, nullable=False)
    username = Column(String, nullable=False)
    created_date = Column(DateTime, server_default=func.now(), nullable=False)
    type = Column(String, nullable=False)

    # Add a check constraint for the 'type' field
    __table_args__ = (
        CheckConstraint(
            type.in_(['student', 'tutor', 'admin']), name='check_type'),
    )
