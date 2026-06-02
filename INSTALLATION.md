# Installation and Setup Guide

This guide details instructions for setting up the development environment, configuring Firebase, and running the **TN Party Connect** application.

## Prerequisites

1. **Flutter SDK**: Install Flutter 3.x (Stable branch) from [flutter.dev](https://flutter.dev/docs/get-started/install). Ensure Dart SDK is bundled.
2. **Java Development Kit (JDK)**: Install JDK 17 (required for Android builds).
3. **Android Studio**: Install and configure Android SDK, virtual device (emulator), and tools.
4. **Git**: Installed and accessible in your shell.
5. **Firebase CLI**: Install the Firebase command-line tools to deploy security rules and configurations. Run:
   ```bash
   npm install -g firebase-tools
   ```

## Development Environment Setup

### 1. Clone & Initialize Branches
```bash
git clone <repository-url>
cd TN-Party-Connect
git checkout -b dev
```

### 2. Set Up the Flutter Project
Navigate to the Flutter project folder and install dependencies:
```bash
cd tn_party_connect
flutter pub get
```

### 3. Firebase Configuration Integration
You need to generate configuration files for your Firebase project:
1. Log in to Firebase CLI:
   ```bash
   firebase login
   ```
2. Activate FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
3. Configure project environments:
   ```bash
   flutterfire configure --project=tn-party-connect-prod
   ```
   *Note: This will generate [firebase_options.dart](file:///d:/Helper/tn_party_connect/lib/firebase_options.dart) in your lib directory.*

## Running the Application

### Debug Mode (Development)
Ensure an Android Emulator is running or a physical device is connected in USB Debugging mode:
```bash
flutter run
```

### Build Production APK
To compile the final release package:
```bash
flutter build apk --release
```
The compiled binary will be stored at:
`build/app/outputs/flutter-apk/app-release.apk`
