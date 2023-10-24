import datetime
from typing import Optional
from pydantic import BaseModel


class UserBase(BaseModel):
    username: str
    email: str
    password: str
    type: str


class UserProfile(BaseModel):
    id: int
    username: str
    email: str
    password: str
    type: str


class UserOut(BaseModel):
    username: str
    email: str
    type: str

    class Config:
        exclude = ["password"]


class UserResponseModel(BaseModel):
    email: str
    username: str
    id: int


class UserCreate(BaseModel):
    username: str
    email: str
    password: str
    type: str


class UserUpdate(BaseModel):
    email: Optional[str] = None
    username: Optional[str] = None
    password: Optional[str] = None
    type: Optional[str] = None


class UserLogin(BaseModel):
    email: str
    password: str


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    id: Optional[str] = None
