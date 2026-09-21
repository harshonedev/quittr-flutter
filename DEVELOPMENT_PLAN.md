# Quittr Development Plan & Codebase Overview

## 1. Project Vision
Quittr is a modular, scalable Flutter app to help users quit addictions and track their recovery. It leverages clean architecture, BLoC state management, and modern Flutter best practices for maintainability and extensibility.

---

## 2. Codebase Structure & Key Concepts

### 2.1. Directory Layout

- **lib/core/**: App-wide utilities, dependency injection, routing, theming, error handling, reusable widgets, and services.
- **lib/features/**: Each feature (auth, onboarding, paywall, home, etc.) is self-contained and follows clean architecture:
  - **data/**: Data sources, models, repository implementations
  - **domain/**: Entities, repository interfaces, use cases
  - **presentation/**: UI screens, widgets, blocs/cubits
- **lib/main.dart**: App entry point, DI setup, theme, and router
- **assets/**: Images, animations, audio, data (JSON)
- **test/**: Unit, widget, and integration tests

### 2.2. Key Technologies
- Flutter 3.x, Dart 3.x, Material 3
- State management: flutter_bloc, Cubit
- Routing: go_router
- Dependency injection: get_it
- Firebase (auth, firestore, storage)
- In-app purchases: in_app_purchase
- Local storage: get_storage, sqflite, shared_preferences
- UI/UX: google_fonts, flutter_svg, lottie, rive
- Notifications: flutter_local_notifications, timezone
- Others: dartz, formz, image_picker, audioplayers, intl, crypto

---

## 3. Feature-by-Feature Plan

### 3.1. Authentication
- [x] Email/Password login
- [x] Forgot password
- [ ] Google, Apple login (not working yet)
- [ ] Add phone authentication (optional)

### 3.2. Onboarding
- [x] Welcome & feature highlights
- [x] Quiz to personalize experience
- [x] Collect user info (name, age)
- [x] Quiz result and recommendations
- [ ] Polish quiz result UI and logic

### 3.3. Paywall & Subscription
- [x] In-app purchase integration
- [x] Multiple subscription plans
- [x] Restore purchases
- [ ] Add terms of service and privacy policy screens
- [ ] Fix UI overflow bugs

### 3.4. Home & Progress
- [x] Relapse tracker
- [x] Progress visualization
- [ ] Add more analytics and insights

### 3.5. Recovery Tools
- [x] Breathing exercises
- [x] Meditation
- [x] Craving control
- [x] Detox support
- [ ] Complete missing logic in detox, breathing, and craving control screens
- [ ] Ensure all buttons and flows work

### 3.6. Journal & Motivation
- [x] Daily journal
- [x] Motivational quotes/content
- [ ] Add more content and polish UI

### 3.7. Profile & Settings
- [x] Edit profile
- [x] App settings
- [x] Side effects tracking
- [ ] Add more settings options
- [ ] Complete side effects tracking

### 3.8. Other
- [x] Library (resources)
- [x] Pledge system
- [x] Reason list
- [ ] Library: Back button not showing
- [ ] "More" button (feature unspecified)

---

## 4. Cross-Cutting Concerns
- [x] Theming (light/dark) and Google Fonts
- [x] Routing with go_router and bottom navigation
- [x] Dependency injection setup
- [x] Local storage and database helpers
- [x] Notification system (partially implemented)
- [x] Custom reusable widgets (e.g., text fields, option tiles)
- [ ] Localization (intl included, not fully used)
- [ ] Error handling and user feedback improvements
- [ ] Performance and accessibility optimizations

---

## 5. Testing & QA
- [ ] Add and run unit, widget, and integration tests
- [ ] Fix bugs and optimize performance
- [ ] Add tests to CI/CD pipeline

---

## 6. Release Preparation
- [ ] Add privacy policy, terms of service
- [ ] Finalize assets and app store requirements
- [ ] Polish onboarding and motivational content

---

## 7. How to Contribute
- Follow the guidelines in `.github/prompts/FLUTTER_GUIDELINES.prompt.md`
- Maintain clean architecture and modularity
- Write tests for new features
- Use BLoC/Cubit for state management
- Use GetIt for dependency injection

---

## 8. Getting Started
1. Clone the repo
2. Run `flutter pub get`
3. Set up Firebase (add your `google-services.json` and `GoogleService-Info.plist`)
4. Run `flutter run`

---

## 9. Known Issues
- Quiz result and paywall screens may overflow on some devices
- Detox screen podcast button not working
- Library back button missing
- "More" button feature incomplete

---

## 10. References
- See `.github/prompts/FLUTTER_GUIDELINES.prompt.md` for coding standards
- See `pubspec.yaml` for all dependencies
- See `README.md` for high-level overview

---
