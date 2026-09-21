# Quittr

> Quittr by Adulting.space

Quittr is a Flutter-based mobile application designed to help users quit addictions and track their recovery journey. The app provides onboarding, quizzes, motivational content, relapse tracking, breathing exercises, and more, with a clean architecture and modular feature structure.

---

## 🛠️ Tools & Technologies Used

- **Flutter 3.x** (Material 3)
- **Dart 3.x**
- **State Management:** flutter_bloc, Cubit
- **Routing:** go_router
- **Dependency Injection:** get_it
- **Firebase:** firebase_core, firebase_auth, cloud_firestore, firebase_storage
- **Local Storage:** get_storage, sqflite, shared_preferences
- **UI & Animations:** google_fonts, flutter_svg, lottie, rive
- **Notifications:** flutter_local_notifications, timezone
- **Other:** dartz, formz, image_picker, audioplayers, intl, crypto

---

## 📁 Project Structure

```
lib/
  core/           # App-wide utilities, DI, routing, theme, error handling
  features/       # Modular features (auth, onboarding, home, etc.)
    auth/
    onboarding/
    home/
    ...           # (breathing_exercise, craving_control, detox, etc.)
  main.dart       # App entry point
```

---

## 📝 Features & Sections

### 1. **Authentication**
- Social login (Google, Apple)
- Email/password login & registration
- Forgot password flow

### 2. **Onboarding**
- Welcome & feature highlights
- Quiz to personalize experience
- Collect user info (name, age)
- Quiz result and recommendations

### 3. **Home & Progress**
- Relapse tracker
- Progress visualization

### 4. **Recovery Tools**
- Breathing exercises
- Meditation
- Craving control
- Detox support

### 5. **Journal & Motivation**
- Daily journal
- Motivational quotes/content

### 6. **Profile & Settings**
- Edit profile
- App settings
- Side effects tracking

### 7. **Other**
- Library (resources)
- Pledge system
- Reason list

---

## ✅ Completed Work

- Modular feature structure with clean architecture
- Authentication (Google, Apple, Email/Password)
- Onboarding flow with quiz and user info collection
- Home screen with relapse tracker
- Breathing, meditation, craving control, and detox screens scaffolded
- Journal, motivation, and reason list screens scaffolded
- Profile and settings screens
- Theming (light/dark) and Google Fonts
- Routing with go_router and bottom navigation
- Dependency injection setup
- Local storage and database helpers
- Notification system (partially implemented)
- Custom reusable widgets (e.g., text fields, option tiles)

---

## 🚧 Incomplete / To-Do

- Fix UI overflows on quiz result screen
- Detox screen: "Listen Podcast" button not working
- Library: Back button not showing
- "More" button (feature unspecified)
- Complete implementation of all feature screens (some are scaffolded only)
- Add terms of service and privacy policy screens
- Improve error handling and user feedback
- Add localization (intl is included but not fully used)
- Add unit, widget, and integration tests
- Polish onboarding and motivational content
- Optimize performance and accessibility

---

## 📅 Development Plan

1. **Polish Onboarding & Quiz**
   - Fix overflow bugs
   - Improve quiz result logic and UI

2. **Complete Recovery Tools**
   - Implement missing logic in detox, breathing, and craving control screens
   - Ensure all buttons and flows work

3. **Enhance Journal, Motivation, and Library**
   - Add content and polish UI
   - Fix navigation issues (e.g., back button)

4. **Profile & Settings**
   - Add more settings options
   - Complete side effects tracking

5. **Testing & QA**
   - Add and run unit, widget, and integration tests
   - Fix bugs and optimize performance

6. **Release Preparation**
   - Add privacy policy, terms of service
   - Finalize assets and app store requirements

---

## 📚 How to Run

1. Clone the repo
2. Run `flutter pub get`
3. Set up Firebase: run `flutterfire configure` (generates `lib/firebase_options.dart`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`). These files are gitignored.
4. Run `flutter run`

---

## 🤝 Contributing

Pull requests are welcome! Please follow the coding and architecture guidelines in `.github/prompts/FLUTTER_GUIDELINES.prompt.md`.

---