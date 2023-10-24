from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from .. import schemas, database, models, utils, oauth2


router = APIRouter(prefix="/users", tags=["Users"])


@router.get("/me")
def get_current_user_data(
    current_user: schemas.UserBase = Depends(oauth2.get_current_user)
):
    return current_user


@router.get("/",)
def get_all_users(
    current_user: schemas.UserBase = Depends(oauth2.get_current_user),
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

    return users


@router.post("/create", response_model=schemas.UserBase, status_code=status.HTTP_201_CREATED)
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
    db.refresh(new_user)

    # Create a UserBase response model
    user_base = schemas.UserBase(
        id=new_user.id,
        username=new_user.username,
        email=new_user.email,
        type=new_user.type,
    )

    return user_base


@router.put("/{user_id}")
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


@router.delete("/{user_id}")
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
