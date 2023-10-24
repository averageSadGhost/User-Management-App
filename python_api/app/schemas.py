import datetime
from typing import Optional
from pydantic import BaseModel


class UserBase(BaseModel):
    it: int
    email: str
    password: str
    username: str
    type: str


class User(BaseModel):
    email: str
    username: str
    type: str


class UserCreate(User):
    password: str


class UserUpdate(BaseModel):
    email: str = None
    username: str = None
    password: str = None
    type: str = None


class UserLogin(BaseModel):
    email: str
    password: str


class User(UserBase):
    password: str
    id: int
    created_date: datetime.datetime

    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    id: Optional[str] = None
