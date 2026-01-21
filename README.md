
# Recipe Finder App

A high-quality Flutter application for browsing and managing recipes using TheMealDB API.

## Features
- **Recipe List**: Browse with Grid/List toggle, sorting (A-Z), and advanced filtering.
- **Search**: Debounced searching by recipe name.
- **Favorites**: Persist favorite recipes offline using Hive.
- **Detail View**: Interactive ingredients, step-by-step instructions, and YouTube integration.
- **Offline Mode**: Access favorited recipes without an internet connection.

## Architecture
- **State Management**: Riverpod (Notifier/Provider)
- **Local Persistence**: Hive (with manual TypeAdapters for portability)
- **Networking**: Dio
- **Clean Code**: Follows SOLID principles and Repository pattern.

## Setup
1. Run `flutter pub get` to install dependencies.
2. Run `flutter run` on your preferred device.

## Testing
- **Unit Tests**: Coverage for models and repositories.
- **Widget Tests**: UI validation for search and cards.
