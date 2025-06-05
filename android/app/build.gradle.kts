plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.dhgc_chat_app"
    compileSdk = flutter.compileSdkVersion
    // ndkVersion = flutter.ndkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.dhgc_chat_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23 // flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Kotlin
    // implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.9.0") // Specify version directly
    
    // Flutter
    implementation("org.jetbrains.kotlin:kotlin-stdlib:2.1.0")
    
    // Firebase
    implementation(platform("com.google.firebase:firebase-bom:32.7.0")) // Recommended BOM approach
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth") {
        exclude(group = "org.jetbrains.kotlin", module = "kotlin-stdlib-jdk8")
    }
    
    // Play Services
    implementation("com.google.android.gms:play-services-auth:21.0.0")
    
    // AndroidX
    implementation("androidx.multidex:multidex:2.0.1")
}

flutter {
    source = "../.."
}
