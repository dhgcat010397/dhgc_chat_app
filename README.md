# dhgc_chat_app


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