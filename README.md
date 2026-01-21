
# Recipe Finder App

A high-quality Flutter application for browsing and managing recipes using TheMealDB API.


<img width="380" height="806" alt="Screenshot 2026-01-21 115709" src="https://github.com/user-attachments/assets/b389bea1-cc9b-4a95-84e5-ea097aba7037" />
<img width="386" height="811" alt="Screenshot 2026-01-21 115634" src="https://github.com/user-attachments/assets/10821325-df09-4d61-9dc6-1dc27f08534a" />
<img width="383" height="802" alt="Screenshot 2026-01-21 115517" src="https://github.com/user-attachments/assets/12c8172d-309f-4da2-b821-16f0ba0be318" />
<img width="385" height="803" alt="Screenshot 2026-01-21 115451" src="https://github.com/user-attachments/assets/e57f3fc5-dbce-4457-a11f-8f90d9115750" />
<img width="376" height="806" alt="Screenshot 2026-01-21 115434" src="https://github.com/user-attachments/assets/f1475ba4-56ee-4065-aaee-b062f69695e4" />
<img width="375" height="799" alt="Screenshot 2026-01-21 115400" src="https://github.com/user-attachments/assets/bb653c77-7510-4cee-8241-7e6c289bf15e" />
<img width="380" height="801" alt="Screenshot 2026-01-21 115333" src="https://github.com/user-attachments/assets/fcf69cd3-177f-4fa7-b716-c347591e5939" />
<img width="383" height="808" alt="Screenshot 2026-01-21 115729" src="https://github.com/user-attachments/assets/5970a6c8-92ff-4141-9d75-caaf3c40b537" />



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
