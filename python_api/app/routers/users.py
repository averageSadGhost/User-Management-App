from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from .. import schemas, database, models, utils, oauth2
from typing import List


router = APIRouter(prefix="/users", tags=["Users"])


@router.get("/me", summary="Get the current user data", description="Get the current authenticated user data")
def get_current_user_data(
    current_user: schemas.UserProfile = Depends(oauth2.get_current_user)
):
    return current_user


@router.get("/", response_model=List[schemas.UserResponseModel], summary="Get list of all avilabe users", description="Get list of all avilabe users depending on the current authenticated user")
def get_all_users(
    current_user: schemas.UserOut = Depends(oauth2.get_current_user),
    db: Session = Depends(database.get_db)
):
    # Check the user type to determine which users to return
    if current_user.type == "admin":
        # Admins can get all tutors and students
        users = db.query(models.User).filter(
            (models.User.type == "tutor") | (models.User.type == "student")
        ).all()

    elif current_user.type == "tutor":
        # Tutors can get all students
        users = db.query(models.User).filter(
            models.User.type == "student").all()
    else:
        # Students shouldn't be able to use this endpoint
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Permission denied"
        )

    # Create a list of UserResponseModel instances
    users_data = [
        schemas.UserResponseModel(
            email=user.email, username=user.username, id=user.id)
        for user in users
    ]

    return users_data


@router.get("/{user_id}", summary="Get user by id", description="Get a user by his id depending on the current authenticated user")
def get_user_by_id(
    user_id: int,
    db: Session = Depends(database.get_db),
    current_user: schemas.UserProfile = Depends(oauth2.get_current_user)
):
    user = db.query(models.User).filter(models.User.id == user_id).first()

    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )

    # Check if the current user has permission to access this user's data
    if not utils.check_access_control(current_user.type, user.type):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Permission denied"
        )

    return user


@router.post("/create", status_code=status.HTTP_201_CREATED,  summary="Create a new user", description="Create a new user, depending on the current authenticated user")
def register_user(
    user: schemas.UserCreate,
    db: Session = Depends(database.get_db),
    current_user=Depends(oauth2.get_current_user)
):
    if not utils.check_access_control(current_user.type, user.type):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Permission denied"
        )

    existing_user = db.query(models.User).filter(
        models.User.email == user.email).first()
    if existing_user:
        raise HTTPException(
            status_code=400, detail="User with this email already exists"
        )

    # Create a new user instance
    new_user = models.User(**user.model_dump())

    # Add the user to the database
    db.add(new_user)
    db.commit()
    # db.refresh(new_user)

    user_base = schemas.UserOut(
        id=new_user.id,
        username=new_user.username,
        email=new_user.email,
        type=new_user.type,
    )

    return user_base


@router.put("/{user_id}", summary="Update user by id", description=" Update a user by his id, depending on the current authenticated user")
def update_user_data(
    user_id: int,
    updated_user: schemas.UserUpdate,
    db: Session = Depends(database.get_db),
    current_user=Depends(oauth2.get_current_user)
):
    # Fetch the user to be updated
    user_to_update = db.query(models.User).filter(
        models.User.id == user_id).first()

    # Check if the user exists
    if not user_to_update:

        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    # Check if the current user has permission to update the target user
    if not utils.check_access_control(current_user.type, user_to_update.type):

        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Permission denied")

    # Update user data
    for key, value in updated_user.dict().items():
        if value is not None:
            setattr(user_to_update, key, value)

    db.commit()
    db.refresh(user_to_update)

    return user_to_update


@router.delete("/{user_id}", summary="Delete user by id", description=" Delete a user by his id, depending on the current authenticated user")
def delete_user(
    user_id: int,
    db: Session = Depends(database.get_db),
    current_user=Depends(oauth2.get_current_user)
):
    # Fetch the user to be deleted
    user_to_delete = db.query(models.User).filter(
        models.User.id == user_id).first()

    # Check if the user exists
    if not user_to_delete:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )

    # Check if the current user has permission to delete the target user
    if not utils.check_access_control(current_user.type, user_to_delete.type):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Permission denied"
        )

    # Delete the user from the database
    db.delete(user_to_delete)
    db.commit()

    return {"message": "User deleted successfully"}
