# FreshBite 🍽️

A modern Flutter-based meal planning and recipe management application designed for the Swiss market, featuring multi-language support (English/German), intelligent meal planning, shopping list management, and cooking skill development.

## 📱 Features

### Core Functionality
- **🏠 Home Dashboard** - Personalized recipe recommendations and featured meals
- **📅 Meal Planner** - Create, manage, and sequence meal plans with drag-and-drop simplicity
- **🛒 Shopping Lists** - Auto-generated shopping lists from meal plans with prep list integration
- **🍳 Recipe Management** - Browse, search, create, and share recipes with detailed instructions
- **👨‍🍳 Cooking Skills** - Track and improve cooking abilities with skill-based recommendations
- **👤 Profile Management** - Manage account settings, family members, and preferences
- **🔐 Authentication** - Secure login/signup with email OTP verification
- **🌐 Multi-language Support** - Full localization in English and German (CHF currency)
- **💳 Subscription Plans** - Free, monthly, and yearly subscription tiers with family options

### Advanced Features
- **📊 Responsive Design** - Optimized for all screen sizes using ScreenUtil
- **🎥 Video Integration** - Instructional cooking videos with custom player
- **📸 Media Support** - Image picker, camera access, and file management
- **📍 Location Services** - Geolocator and Google Maps integration
- **📄 PDF Generation** - Export meal plans and shopping lists to PDF
- **🎉 Celebrations** - Confetti animations for achievements
- **🔔 Push Notifications** - Real-time updates and reminders (planned)

## 🏗️ Architecture

### Pattern
**Feature-First MVC** with GetX for state management and dependency injection

```
lib/
├── core/                 # Shared utilities, themes, widgets
│   ├── themes/          # App colors, text styles, images
│   ├── widgets/         # Reusable UI components
│   ├── network_celler/  # HTTP client & API endpoints
│   └── navbar/          # Bottom navigation
├── features/            # Feature modules
│   ├── auth/            # Login, signup, forgot password
│   ├── home/            # Home dashboard & cooking skills
│   ├── meal_planner/    # Meal planning & sequencing
│   ├── recepies/        # Recipe search, details, creation
│   ├── shopping_list/   # Shopping list management
│   ├── profile/         # User profile & settings
│   ├── subscription/    # Subscription plans
│   ├── guest_mode/      # Guest access (in development)
│   └── new/             # New features (in development)
├── localization/        # Internationalization (EN/DE)
├── routes/              # Navigation routing
└── main.dart            # Application entry point
```

### State Management
**GetX Framework** (`get: ^4.7.2`)
- Reactive state with `.obs` observables
- Auto-updating UI with `Obx()` widgets
- Dependency injection with `Get.put()` / `Get.find()`
- Navigation with `Get.to()`, `Get.offAll()`, named routes
- Built-in snackbar and dialog utilities

### API Integration
**Base URL**: `https://ibrahim8000.sobhoy.com/api/v1`

Custom HTTP client with:
- Automatic JWT token injection
- Token expiration handling (auto-logout on 401)
- Support for GET, POST, PATCH, DELETE, and multipart requests
- Bearer token authentication via SharedPreferences

**Key Endpoints**:
- **Auth**: `/auth/sign-in`, `/auth/forgot-password`, `/auth/get-my-profile`
- **Recipes**: `/recipe/get-all-recipe`, `/user-recipe/get-recipes`, `/user-recipe/create-recipe`
- **Meal Planner**: `/mealplan/create-meal`, `/mealplan/get-meal-plan`, `/mealplan/commnets-meal-plan/:id`
- **Shopping**: `/shopping/get-my-shopping-lists`, `/shopping/create-shopping-list`
- **Prep List**: `/preplist/get-prepList`
- **Skills**: `/skill/get-all-skill`, `/skill/get-skill/:id`
- **Sequences**: `/sequence/create-sequence-meal`, `/sequence/get-sequence-meal`

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `^3.9.0`
- **Dart SDK**: `^3.9.0`
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA
- **Device**: Android/iOS emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd freshbite
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment** (if needed)
   - Update API base URL in `lib/core/network_celler/endpoints.dart`
   - Add Google Maps API key (for location features)

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android**:
```bash
flutter build apk --release
flutter build appbundle --release
```

**iOS**:
```bash
flutter build ios --release
```

## 📦 Key Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `get` | ^4.7.2 | State management, routing, DI |
| `http` | ^1.4.0 | HTTP client |
| `shared_preferences` | ^2.5.3 | Local storage & token management |
| `flutter_screenutil` | ^5.9.3 | Responsive design |
| `google_fonts` | ^6.2.1 | Rubik font family |
| `flutter_svg` | ^2.2.0 | SVG rendering |
| `image_picker` | ^1.1.2 | Image selection |
| `video_player` | ^2.7.2 | Video playback |
| `audioplayers` | ^6.5.1 | Audio playback |
| `camera` | ^0.11.0 | Camera access |
| `sqflite` | ^2.3.0 | Local SQLite database |
| `pdf` / `printing` | ^3.10.8 / ^5.12.0 | PDF generation & printing |
| `confetti` | ^0.7.0 | Celebration animations |
| `intl_phone_field` | ^3.2.0 | Phone number input |
| `permission_handler` | ^12.0.1 | Runtime permissions |
| `geolocator` | ^14.0.0 | Location services |
| `google_maps_flutter` | ^2.12.1 | Google Maps integration |

## 🌐 Localization

Supports **English** (en_US) and **German** (de_DE) with 1180+ translation keys covering:
- Authentication flows
- Recipe management
- Meal planner
- Shopping lists
- Settings & profile
- Subscription plans

Locale is persisted using SharedPreferences and can be changed in-app via the profile settings.

## 🎨 Design System

### Colors
- **Primary**: Dark Green `#1C2D07`
- **Accent**: Gold `#E8B86D`
- **Green Tones**: 50-900 scale for consistency
- **Status Colors**: Error (red), Success (green), Warning (orange)
- **Predefined Gradients**: Ready-to-use gradient combinations

### Typography
- **Font Family**: Baste B (custom, weight 900)
- **Google Fonts**: Rubik for body text
- **Responsive Sizing**: Using ScreenUtil (`.sp` extension)
- **Text Styles**: H1-H6, HeadBold, BodyLarge/Medium/Small, Button, Caption, Label

### Responsive Design
- **Design Size**: 376x812 (iPhone X dimensions)
- **ScreenUtil Initialization**: Automatic scaling for all screen sizes

## 📁 Assets Structure

```
assets/
├── images/      # PNG/JPG images (logos, placeholders, backgrounds)
├── icons/       # App icons
├── svg/         # SVG graphics
├── audio/       # Audio files
├── video/       # Video files
└── navbar/      # Navigation bar icons
```

## 🔧 Development

### Code Structure
Each feature module follows a consistent pattern:
```
feature_name/
├── controllers/    # GetX controllers (business logic)
├── screens/        # UI screens (views)
├── models/         # Data models with JSON serialization
└── services/       # API services (network calls)
```

### Adding a New Feature
1. Create feature directory under `lib/features/`
2. Add controller(s) extending `GetxController`
3. Add model(s) with `fromJson`/`toJson`
4. Add service(s) for API calls
5. Add screen(s) with UI
6. Register route in `lib/routes/routes.dart`
7. Add translations in `lib/localization/`

### Running Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
flutter format .
```

## 📝 Documentation

Additional guides available:
- [Home Screen UI Update Guide](HOME_SCREEN_UI_UPDATE_GUIDE.md) - Real API data integration
- [Meal Plan API Integration Guide](MEAL_PLAN_API_INTEGRATION_GUIDE.md) - Meal planning APIs

## 🚧 In Development

The following features are partially implemented or planned:
- **Guest Mode** - Limited access without login (stub directories exist)
- **Video Features** - Instructional video player (single file, no controller)
- **Family/Linked Accounts** - Parent-child account relationships
- **Password Reset Flow** - OTP verification (partially wired)
- **Subscription Integration** - Payment processing (UI complete, backend pending)

## 🐛 Troubleshooting

### Common Issues

**API returns 401 Unauthorized**
- Clear app data or reinstall to remove expired token
- Verify backend JWT expiration settings

**Profile image not loading**
- Check image URL validity in API response
- Network image loading uses Flutter's default caching

**Localization not updating**
- Check SharedPreferences persistence
- Restart app to apply locale changes

### Debug Mode
Enable verbose logging in `lib/core/network_celler/http_client.dart` to inspect API requests/responses.

## 📄 License

This project is proprietary software. All rights reserved.

## 👥 Team

Developed by the FreshBite team for the Swiss market.

## 📞 Support

For questions or issues, please refer to the in-app FAQ section or contact support.

---

**Built with ❤️ using Flutter & GetX**
