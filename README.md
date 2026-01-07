# Flutter Clean Architecture User Management App

A Flutter mobile application demonstrating Clean Architecture, proper state management using BLoC, and REST API integration with [ReqRes](https://reqres.in/).

## Features

- **User Listing**: Fetch users with pagination (infinite scrolling).
- **Create User**: Add new users (simulation).
- **Update User**: Edit existing user details (simulation).
- **Delete User**: Remove users (simulation).
- **State Management**: Uses `flutter_bloc` to handle Loading, Success, and Error states.
- **Clean Architecture**: Separation of concerns into Presentation, Domain, and Data layers.

## Architecture

The project follows Clean Architecture principles:

- **Presentation Layer** (`lib/features/users/presentation`): Contains BLoC, Pages, and Widgets.
- **Domain Layer** (`lib/features/users/domain`): Contains Entities, UseCases, and Repository Interfaces. This layer is independent of external data sources.
- **Data Layer** (`lib/features/users/data`): Contains Models, Repository Implementations, and Data Sources (API calls).

### Folder Structure

```
lib/
├── core/                # Core reusable components (Error, Network, Theme, UseCase)
├── features/
│   └── users/           # User Management Feature
│       ├── data/        # Data Layer (Models, Repositories, Data Sources)
│       ├── domain/      # Domain Layer (Entities, UseCases, Repository Contracts)
│       └── presentation/# Presentation Layer (BLoC, Pages)
├── injection_container.dart # Dependency Injection Setup (GetIt)
└── main.dart            # App Entry Point
```

## Setup & Run

1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd lambda_tassk
    ```

2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the App**:
    ```bash
    flutter run
    ```

## API Details
- Base URL: `https://reqres.in/api`
- Endpoints:
  - `GET /users?page={page}`: List users.
  - `POST /users`: Create user.
  - `PUT /users/{id}`: Update user.
  - `DELETE /users/{id}`: Delete user.

## State Management
Uses **BLoC (Business Logic Component)** to manage state.
- **Events**: `LoadUsers`, `CreateUserEvent`, `UpdateUserEvent`, `DeleteUserEvent`
- **States**: `UserInitial`, `UserLoading`, `UserLoaded`, `UserOperationSuccess`, `UserError`
