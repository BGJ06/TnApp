# Deployment Guide

This guide details steps required to build and deploy the **TN Party Connect** system to production environments.

---

## 1. Deploying Firebase Services

Before deploying, ensure you have installed the Firebase CLI and run `firebase login`.

### Initialize Project Config
Make sure your active project is pointed to your production target:
```bash
firebase use --add
```

### Deploy Firestore Security Rules & Indexes
Deploy rules file (`firestore.rules`) and composite indices (`firestore.indexes.json`):
```bash
firebase deploy --only firestore
```

### Deploy Storage Security Rules
Set up access constraints for profile images and uploads:
```bash
firebase deploy --only storage
```

### Deploy Cloud Functions (Escalation Engine)
Deploy serverless handlers for triggering SOS escalation push alerts:
```bash
firebase deploy --only functions
```

---

## 2. Compiling the Flutter Mobile App (Android)

To publish the application on Google Play Store or distribute it as an APK, complete the production build pipeline:

### Configure App Signing
1. Generate an upload keystore:
   ```bash
   keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Create [key.properties](file:///d:/Helper/tn_party_connect/android/key.properties) in `tn_party_connect/android/`:
   ```properties
   storePassword=yourKeystorePassword
   keyPassword=yourKeyPassword
   keyAlias=upload
   storeFile=upload-keystore.jks
   ```
3. Update [build.gradle](file:///d:/Helper/tn_party_connect/android/app/build.gradle) to reference the signing credentials:
   ```gradle
   def keystorePropertiesFile = rootProject.file('key.properties')
   def keystoreProperties = new Properties()
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new java.io.FileInputStream(keystorePropertiesFile))
   }
   
   android {
       signingConfigs {
           release {
               keyAlias keystoreProperties['keyAlias']
               keyPassword keystoreProperties['keyPassword']
               storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
               storePassword keystoreProperties['storePassword']
           }
       }
       buildTypes {
           release {
               signingConfig signingConfigs.release
               minifyEnabled true
               shrinkResources true
               proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
           }
       }
   }
   ```

### Compile App Bundle (AAB) or APK
For publishing to Play Store (Google Play Console accepts App Bundles):
```bash
flutter build appbundle --release
```
To generate an APK for side-loading or direct distribution:
```bash
flutter build apk --release --split-per-abi
```
Outputs are compiled to:
`build/app/outputs/bundle/release/app-release.aab` and `build/app/outputs/flutter-apk/`
