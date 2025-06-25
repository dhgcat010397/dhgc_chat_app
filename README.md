# dhgc_chat_app

This project is a realtime chat app with features:
1. Sign by email and password
2. Register by email, password, fullname
3. Sign via third-party: google sign
4. Chat realtime 1-1

This project apply Clean Architecture and use BLoC for state management, uses Firebase for authentication, store messages and push notification (this feature are developing).

---

**My `build.gradle.kts` is Kotlin, so all configs will use Kotlin DSL syntax**

---

## Environment Variables

1. Copy `.env.example` to `.env`
2. Fill in your real API keys in `.env`


## 🔥 Firebase Setup

### 1. Get Your Firebase Config Files

- **Android:**  
  Download `google-services.json` from your [Firebase Console](https://console.firebase.google.com/) and place it in:  `android/app/google-services.json`

- **iOS:**  
Download `GoogleService-Info.plist` from your [Firebase Console](https://console.firebase.google.com/) and place it in:  `ios/Runner/GoogleService-Info.plist`


### 2. Do NOT Commit These Files

These files contain sensitive information.  
They are already listed in `.gitignore` and should **not** be committed to the repository.

### 3. Use Example Files for Reference

This project provides:
- `android/app/google-services.example.json`
- `ios/Runner/GoogleService-Info.example.plist`

Copy these files and rename them as above, then fill in your real Firebase credentials.

---

**Never share your real Firebase config files in a public repository!**

---

## Firebase Push Notification

Add the following to your `android/app/build.gradle`:

### 1. Enable core library desugaring in `compileOptions`:

```kotlin
android {
    // ...existing code...
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }
}
```

### 2. Add the desugaring library to dependencies:

```kotlin
dependencies {
    // ...existing dependencies...
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
```
