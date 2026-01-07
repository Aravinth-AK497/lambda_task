Flutter User Management App

A clean and scalable Flutter application built to demonstrate Clean Architecture and BLoC state management in a real-world setup.

This project uses the public ReqRes API as a dummy backend for user data.

Overview

Welcome to the User Management App.

This project is more than a basic CRUD example. It is designed to reflect how a production-ready Flutter application should be structured and built. The focus is on clean separation of concerns, predictable state management, and a polished user experience.

If you’re exploring best practices in Flutter architecture, pagination, API integration, or web compatibility, this project is intended to serve as a solid reference.

Key Features

Modern UI
A clean and minimal interface with rounded cards, balanced spacing, and consistent theming.

Smooth Animations

Staggered list animations for user cards

Hero transitions between list and detail views

Shimmer-based skeleton loaders for better loading feedback

Clean Architecture
The codebase is structured into Presentation, Domain, and Data layers to ensure maintainability and testability.

State Management with BLoC
Uses flutter_bloc for clear event–state flow and predictable UI updates.

Pagination
Implements infinite scrolling for efficient user loading.

Web Support
Configured to work smoothly on Flutter Web, including CORS handling.

Architecture

This project follows Clean Architecture principles, ensuring that business logic is independent of UI and external frameworks.

lib/
├── core/                      # Common utilities (theme, errors, base use cases)
├── features/
│   └── users/                 # User management feature
│       ├── data/              # API services, DTOs, repositories
│       ├── domain/            # Entities and use cases
│       └── presentation/      # BLoC, screens, and widgets
└── injection_container.dart   # Dependency injection setup (GetIt)

Getting Started

Follow the steps below to run the project locally.

Prerequisites

Flutter SDK installed

Basic knowledge of Flutter and Dart

Installation

Clone the repository

git clone https://github.com/Aravinth-AK497/lambda_task.git
cd lambda_task


Install dependencies

flutter pub get


Run the application

flutter run


For Flutter Web:

flutter run -d chrome --web-renderer html

Libraries & Tools Used

flutter_bloc – State management using the BLoC pattern

dio – REST API integration with timeout and error handling

get_it – Dependency injection

animate_do – Entry and transition animations

shimmer – Skeleton loading effects

dartz – Functional programming utilities for error handling