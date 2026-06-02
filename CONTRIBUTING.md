# Contributing Guidelines

Thank you for contributing to **TN Party Connect**. Please review these guidelines before submitting changes.

## Git Branching Strategy

We enforce a multi-branch development lifecycle:

1. **`main`**: Production-ready branch. Only merges from `release` or critical hotfixes are permitted here.
2. **`dev`**: Integration branch for new features and bug fixes. All feature branches branch off from `dev` and merge back into `dev`.
3. **Feature Branches (`feature/your-feature-name`)**: Dedicated branches for specific items.

### Branch Lifecycle Workflow:
```bash
git checkout dev
git pull origin dev
git checkout -b feature/auth-otp
# Work on code...
git add .
git commit -m "Auth: Implement mobile OTP verification flows"
git push origin feature/auth-otp
```

## Commit Message Standards

Use descriptive, prefix-based commit messages:

- `Setup`: Initial setup or configurations (e.g. `Setup: Initialize Flutter and base routing`)
- `Auth`: User login, registration, and OTP authentication
- `Dir`: Public leadership directory listing and sorting filters
- `SOS`: Emergency alerts, location updates, and FCM notification triggers
- `IT`: IT Wing and influencer capabilities, database changes
- `Docs`: Documentation additions or modifications

## Coding Guidelines

1. **Architecture**: Adhere to clean architecture patterns:
   - Separate concerns across presentation layer (widgets/screens), domain layer (entities/usecases), and data layer (models/repositories).
2. **State Management**: Keep widgets stateless where possible. Use Riverpod/Provider state controllers to manage reactive elements.
3. **Material 3 UI**: Follow the design language tokens. Use custom style classes and themes instead of overriding individual colors inline.
4. **Dart Formatting**: Always run:
   ```bash
   flutter format .
   ```
   Before making commits. Ensure all files pass code quality checks.
