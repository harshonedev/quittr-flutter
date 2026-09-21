# GitHub Copilot Rules for Flutter Projects

## Flexibility Notice
These are recommended practices. If the project already follows a different structure or architecture, prioritize consistency over strict enforcement. Adapt the suggestions to align with the current codebase.

---

## Flutter Best Practices

- Adapt to existing architecture while maintaining clean code
- Use Flutter 3.x and Material 3
- Follow Clean Architecture using the BLoC pattern
- Use proper state management principles
- Implement dependency injection using GetIt
- Handle errors using the Either type (from `dartz` or equivalent)
- Apply localization with Flutter's `intl`
- Respect platform-specific UI/UX guidelines

---

## Recommended Project Structure (Reference)

```
lib/
  core/
    constants/
    theme/
    utils/
    widgets/
  features/
    feature_name/
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        bloc/
        pages/
        widgets/
  l10n/
  main.dart
test/
  unit/
  widget/
  integration/
```

Note: Adapt to your existing structure. This is just a reference.

---

## Coding Guidelines

1. Use null safety everywhere
2. Implement error handling with Either
3. Follow standard naming conventions
4. Compose UI with reusable widgets
5. Use GoRouter for routing
6. Apply form validation correctly
7. Prefer BLoC for state management
8. Inject dependencies with GetIt
9. Manage and reference assets properly
10. Write unit, widget, and integration tests

Note : Trying to understand and read the existing code & files first.

---

## Widget Guidelines

1. Keep widgets small and focused
2. Use const constructors where possible
3. Add keys when required (especially in lists)
4. Avoid deep nesting; follow layout principles
5. Respect widget lifecycle
6. Add error boundaries as needed
7. Use performance optimizations (e.g., const, AutomaticKeepAliveClientMixin)
8. Follow accessibility standards (semantics, screen readers)

---

## Performance Guidelines

1. Use image caching (e.g., `cached_network_image`)
2. Optimize list views (e.g., `ListView.builder`)
3. Avoid heavy logic in build methods
4. Manage state efficiently with Cubit/BLoC
5. Clean up resources (e.g., dispose `TextEditingController`)
6. Use platform channels only when needed
7. Build with optimization flags

---

## Testing Guidelines

1. Write unit tests for business logic
2. Implement widget tests for UI
3. Add integration tests for features
4. Use proper mocking strategies
5. Ensure good test coverage
6. Follow test naming conventions  
   Example: `shouldDisplayError_whenLoginFails`
7. Add tests to your CI/CD pipeline
