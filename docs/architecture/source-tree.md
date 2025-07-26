# Source Tree Structure - NutryFlow

## Overview

NutryFlow follows a **Feature-First Clean Architecture** pattern, organizing code by business features rather than technical layers. This approach promotes modularity, testability, and maintainability.

## Root Directory Structure

```
nutry_flow/
├── .github/                    # GitHub workflows and templates
│   └── workflows/
│       ├── ci.yml             # Continuous Integration
│       ├── cd.yml             # Continuous Deployment
│       └── pr-checks.yml      # Pull Request checks
├── android/                   # Android-specific configuration
│   ├── app/
│   │   ├── build.gradle.kts   # Android app build configuration
│   │   └── src/
│   │       ├── main/
│   │       │   ├── AndroidManifest.xml
│   │       │   ├── kotlin/    # Android-specific Kotlin code
│   │       │   └── res/       # Android resources
│   │       ├── debug/         # Debug configuration
│   │       └── profile/       # Profile configuration
│   ├── build.gradle.kts       # Android project build configuration
│   └── gradle/                # Gradle wrapper
├── ios/                       # iOS-specific configuration
│   ├── Runner/
│   │   ├── AppDelegate.swift  # iOS app delegate
│   │   ├── Info.plist         # iOS app configuration
│   │   └── Assets.xcassets/   # iOS assets
│   ├── Runner.xcodeproj/      # Xcode project
│   └── Runner.xcworkspace/    # Xcode workspace
├── lib/                       # Main Flutter application code
│   ├── app.dart              # Main application entry point
│   ├── main.dart             # Flutter app entry point
│   ├── core/                 # Core application infrastructure
│   ├── features/             # Feature modules
│   ├── shared/               # Shared components and utilities
│   └── screens/              # Legacy screens (to be refactored)
├── test/                     # Test files
├── docs/                     # Project documentation
├── assets/                   # Static assets
├── web/                      # Web-specific configuration
├── windows/                  # Windows-specific configuration
├── linux/                    # Linux-specific configuration
├── macos/                    # macOS-specific configuration
├── pubspec.yaml              # Flutter project configuration
├── analysis_options.yaml    # Dart analysis configuration
└── README.md                 # Project documentation
```

## Core Directory (`lib/core/`)

Contains shared infrastructure and utilities used across features.

```
lib/core/
├── config/                   # Configuration files
│   ├── app_config.dart      # Application configuration
│   ├── environment.dart     # Environment-specific settings
│   └── supabase_config.dart # Supabase configuration
├── constants/               # Application constants
│   ├── api_constants.dart   # API endpoints and keys
│   ├── app_constants.dart   # General app constants
│   └── storage_keys.dart    # Local storage keys
├── errors/                  # Error handling
│   ├── exceptions.dart      # Custom exceptions
│   ├── failures.dart        # Failure classes
│   └── error_handler.dart   # Global error handling
├── network/                 # Network layer
│   ├── dio_client.dart      # HTTP client configuration
│   ├── interceptors/        # Network interceptors
│   └── network_info.dart    # Network connectivity
├── services/                # Core services
│   ├── auth_service.dart    # Authentication service
│   ├── storage_service.dart # Local storage service
│   ├── navigation_service.dart # Navigation service
│   └── notification_service.dart # Push notifications
├── utils/                   # Utility functions
│   ├── date_utils.dart      # Date manipulation utilities
│   ├── validation_utils.dart # Input validation
│   ├── format_utils.dart    # Data formatting
│   └── device_utils.dart    # Device information
└── di/                      # Dependency injection
    ├── injection_container.dart # GetIt configuration
    └── injection_container.config.dart # Generated DI config
```

## Features Directory (`lib/features/`)

Each feature follows Clean Architecture principles with three layers:

```
lib/features/
├── auth/                    # Authentication feature
│   ├── data/               # Data layer
│   │   ├── datasources/    # Data sources (API, local)
│   │   ├── models/         # Data models
│   │   ├── repositories/   # Repository implementations
│   │   └── services/       # Feature-specific services
│   ├── domain/             # Domain layer
│   │   ├── entities/       # Business entities
│   │   ├── repositories/   # Repository interfaces
│   │   └── usecases/       # Business use cases
│   ├── presentation/       # Presentation layer
│   │   ├── bloc/           # BLoC state management
│   │   ├── pages/          # Page widgets
│   │   └── widgets/        # Feature-specific widgets
│   └── di/                 # Feature dependency injection
│       └── auth_dependencies.dart
├── profile/                # User profile feature
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   └── di/
├── nutrition/              # Nutrition tracking feature
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   └── di/
├── meal_plan/              # Meal planning feature
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   └── di/
├── exercise/               # Exercise tracking feature
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   └── di/
├── dashboard/              # Dashboard feature
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   └── di/
├── menu/                   # Recipe/menu feature
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   └── di/
├── calendar/               # Calendar feature
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   └── di/
├── grocery_list/           # Grocery list feature
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   └── di/
├── notifications/          # Notifications feature
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   └── di/
└── onboarding/             # Onboarding feature
    ├── data/
    ├── domain/
    ├── presentation/
    └── di/
```

## Feature Layer Structure

### Data Layer (`feature/data/`)

```
data/
├── datasources/
│   ├── local/
│   │   └── feature_local_datasource.dart
│   └── remote/
│       └── feature_remote_datasource.dart
├── models/
│   ├── feature_model.dart
│   └── feature_response.dart
├── repositories/
│   └── feature_repository_impl.dart
└── services/
    └── feature_service.dart
```

### Domain Layer (`feature/domain/`)

```
domain/
├── entities/
│   └── feature_entity.dart
├── repositories/
│   └── feature_repository.dart
├── usecases/
│   ├── get_feature_usecase.dart
│   ├── create_feature_usecase.dart
│   └── update_feature_usecase.dart
└── models/
    └── feature_request.dart
```

### Presentation Layer (`feature/presentation/`)

```
presentation/
├── bloc/
│   ├── feature_bloc.dart
│   ├── feature_event.dart
│   └── feature_state.dart
├── pages/
│   ├── feature_page.dart
│   └── feature_detail_page.dart
├── widgets/
│   ├── feature_card.dart
│   ├── feature_list.dart
│   └── feature_form.dart
└── utils/
    └── feature_validators.dart
```

## Shared Directory (`lib/shared/`)

Contains reusable components and utilities shared across features.

```
lib/shared/
├── design/                 # Design system components
│   ├── components/         # Reusable UI components
│   │   ├── buttons/        # Button components
│   │   ├── inputs/         # Input components
│   │   ├── cards/          # Card components
│   │   ├── dialogs/        # Dialog components
│   │   └── navigation/     # Navigation components
│   └── tokens/             # Design tokens
│       ├── colors.dart     # Color palette
│       ├── typography.dart # Typography styles
│       ├── spacing.dart    # Spacing values
│       └── shadows.dart    # Shadow definitions
├── theme/                  # Application theming
│   ├── app_theme.dart      # Main theme configuration
│   ├── app_colors.dart     # Color definitions
│   ├── app_styles.dart     # Text styles
│   └── theme_extensions.dart # Theme extensions
├── widgets/                # Shared widgets
│   ├── app_bar.dart        # Custom app bar
│   ├── bottom_navigation.dart # Bottom navigation
│   ├── loading_indicator.dart # Loading widgets
│   ├── error_widget.dart   # Error display widgets
│   └── empty_state.dart    # Empty state widgets
├── extensions/             # Dart extensions
│   ├── context_extensions.dart # BuildContext extensions
│   ├── string_extensions.dart # String extensions
│   └── datetime_extensions.dart # DateTime extensions
└── mixins/                 # Reusable mixins
    ├── validation_mixin.dart # Validation logic
    └── loading_mixin.dart   # Loading state management
```

## Test Directory Structure

```
test/
├── unit/                   # Unit tests
│   ├── core/              # Core functionality tests
│   └── features/          # Feature-specific tests
│       └── auth/
│           ├── data/
│           ├── domain/
│           └── presentation/
├── widget/                 # Widget tests
│   ├── shared/            # Shared widget tests
│   └── features/          # Feature widget tests
├── integration/            # Integration tests
│   ├── auth_flow_test.dart
│   └── meal_tracking_test.dart
├── mocks/                  # Mock objects
│   ├── mock_repositories.dart
│   └── mock_services.dart
└── helpers/                # Test helpers
    ├── test_helpers.dart
    └── widget_test_helpers.dart
```

## Assets Directory Structure

```
assets/
├── images/                 # Image assets
│   ├── icons/             # App icons
│   ├── illustrations/     # Illustrations
│   ├── backgrounds/       # Background images
│   └── logos/             # Logo variations
├── fonts/                 # Custom fonts
├── data/                  # Static data files
│   ├── nutrition_data.json
│   └── exercise_data.json
└── animations/            # Animation files
    └── lottie/            # Lottie animations
```

## Documentation Structure

```
docs/
├── architecture/          # Architecture documentation
│   ├── coding-standards.md
│   ├── tech-stack.md
│   └── source-tree.md
├── api/                   # API documentation
├── user-guides/           # User documentation
├── deployment/            # Deployment guides
├── scrum/                 # Scrum documentation
├── stories/               # User stories
└── epics/                 # Epic documentation
```

## Key Principles

### 1. Feature-First Organization
- Each feature is self-contained
- Features can be developed independently
- Clear boundaries between features

### 2. Clean Architecture Layers
- **Presentation**: UI and state management
- **Domain**: Business logic and entities
- **Data**: Data sources and repositories

### 3. Dependency Direction
- Presentation depends on Domain
- Data depends on Domain
- Domain has no dependencies on other layers

### 4. Shared Code
- Common utilities in `core/`
- Reusable components in `shared/`
- Design system in `shared/design/`

### 5. Testing Strategy
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for user flows

### 6. Code Generation
- JSON serialization with `json_serializable`
- Dependency injection with `injectable`
- Route generation with `go_router`

## File Naming Conventions

### Dart Files
- Use snake_case for file names
- Add descriptive suffixes:
  - `_bloc.dart` for BLoC classes
  - `_event.dart` for event classes
  - `_state.dart` for state classes
  - `_model.dart` for data models
  - `_entity.dart` for domain entities
  - `_repository.dart` for repositories
  - `_usecase.dart` for use cases
  - `_service.dart` for services
  - `_widget.dart` for widgets
  - `_page.dart` for pages

### Test Files
- Mirror the source structure
- Add `_test.dart` suffix
- Group related tests in the same file

### Asset Files
- Use descriptive names
- Group by type and feature
- Use consistent naming patterns

## Import Organization

### Import Order
1. Dart/Flutter imports
2. Third-party package imports
3. Local imports (relative paths)

### Import Grouping
```dart
// Dart/Flutter imports
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

// Third-party imports
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

// Local imports
import '../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user.dart';
```

This structure ensures maintainability, scalability, and clear separation of concerns throughout the NutryFlow application. 