# User Management App

The User Management App is a project that combines a FastAPI backend for user management and a Flutter app for user interaction. The FastAPI backend allows you to perform various user-related operations, while the Flutter app provides a user-friendly interface for managing users.

## Features

- **FastAPI Backend**:

  - User registration and management.
  - User login and token-based authentication.
  - Role-based access control for users (admin, tutor, student).
  - CRUD operations for user data (Create, Read, Update, Delete).
  - User uptime information.

- **Flutter App**:
  - User login with email and password.
  - User interface for administrators and tutors.
  - View, add, edit, and delete users.
  - Display user details.

## Technologies Used

- **Backend**:

  - [FastAPI](https://fastapi.tiangolo.com/): A modern, fast web framework for building APIs with Python.
  - [SQLAlchemy](https://www.sqlalchemy.org/): An SQL toolkit and Object-Relational Mapping (ORM) library.
  - [Pydantic](https://pydantic-docs.helpmanual.io/): Data validation and parsing library.

- **Frontend**:
  - [Flutter](https://flutter.dev/): A UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
  - [Dio](https://pub.dev/packages/dio): A powerful HTTP client for Dart.
  - [GetX](https://pub.dev/packages/get): A state management library for Flutter.

## Getting Started

### Backend Setup

1. Navigate to the `User-Management-App/python_api` directory.
2. Create a virtual environment: `python -m venv venv`.
3. Activate the virtual environment:
   - On Windows: `venv\Scripts\activate`
   - On macOS and Linux: `source venv/bin/activate`
4. Install the required packages: `pip install -r requirements.txt`.
5. Start the FastAPI server: `uvicorn python_api.app.main:app --host 0.0.0.0 --port 8000`.

### Flutter App Setup

1. Navigate to the `User-Management-App/flutter_app
/manage_app/
` directory.
2. Run `flutter pub get` to fetch the app's dependencies.
3. If you are on android emulator, you should change the url found in utils.dart from `http://127.0.0.1:8000` to `http://10.0.2.2:8000` both can be found in the utils.dart
4. Start the Flutter app: `flutter run`.

## Usage

- Access the FastAPI Swagger documentation at `http://localhost:8000/docs` to explore and interact with the backend API.
- Launch the Flutter app on an emulator or physical device to use the frontend.
- Log in as an administrator or tutor to manage users.
- Some accounts i created, email: admin@email.com passwrod: admin, email: tutor@email.com password: tutor, email: student@email.com password: student
