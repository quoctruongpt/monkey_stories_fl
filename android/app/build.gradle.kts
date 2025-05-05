plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.monkey_stories"
    compileSdk = flutter.compileSdkVersion
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
        applicationId = "com.earlystart.android.monkeyjunior.story"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // minSdk = flutter.minSdkVersion
        targetSdk = 33
        versionCode = 2
        versionName = "4.0.0"
        minSdkVersion(22)
    }

    signingConfigs {
        create("release") {
            // These variables should be defined in your gradle.properties or environment
            // storeFile.set(file(providers.gradleProperty("MY_KEYSTORE_FILE").get()))
            // storePassword.set(providers.gradleProperty("MY_KEYSTORE_PASSWORD").get())
            // keyAlias.set(providers.gradleProperty("MY_KEY_ALIAS").get())
            // keyPassword.set(providers.gradleProperty("MY_KEY_PASSWORD").get())

            // Placeholder for syntax correction - ensure these variables are defined elsewhere
             if (project.hasProperty("MY_KEYSTORE_FILE")) {
                storeFile = file(project.property("MY_KEYSTORE_FILE") as String)
             }
             if (project.hasProperty("MY_KEYSTORE_PASSWORD")) {
                 storePassword = project.property("MY_KEYSTORE_PASSWORD") as String
             }
             if (project.hasProperty("MY_KEY_ALIAS")) {
                 keyAlias = project.property("MY_KEY_ALIAS") as String
             }
             if (project.hasProperty("MY_KEY_PASSWORD")) {
                 keyPassword = project.property("MY_KEY_PASSWORD") as String
             }
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(project(":unityLibrary"))
}