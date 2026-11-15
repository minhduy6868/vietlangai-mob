plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "vn.ngonsacviet.ngon_sac_viet"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "vn.ngonsacviet.ngon_sac_viet"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        ndk {
            // Phone sideload APK: arm64 only (drops x86/armeabi ML Kit natives).
            abiFilters += listOf("arm64-v8a")
        }
    }

    buildTypes {
        release {
            // Sideload APK for phone download; minify to fit Cloudflare Pages file limit.
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

flutter {
    source = "../.."
}

// Sideload APK size: drop on-device OCR natives/models (phone can still use web/API later).
android {
    packaging {
        jniLibs {
            excludes += listOf("**/libmlkit_google_ocr_pipeline.so")
        }
        resources {
            excludes += listOf(
                "**/mlkit-google-ocr-models/**",
                "META-INF/DEPENDENCIES",
                "META-INF/LICENSE*",
                "META-INF/NOTICE*",
            )
        }
    }
}
