plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle Plugin은 Android 및 Kotlin Gradle Plugin 이후에 적용되어야 합니다.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // 네임스페이스 및 SDK 버전 설정
    namespace = "com.example.flutter_application_5"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"  // 여기에 Android NDK 버전을 설정합니다.

    compileOptions {
        // Java 11을 사용하는 경우의 호환성 설정
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()  // Kotlin JVM 타겟을 Java 11로 설정
    }

    defaultConfig {
        // 패키지 ID와 SDK 설정
        applicationId = "com.example.flutter_application_5"
        minSdk = flutter.minSdkVersion  // Flutter에서 정의한 최소 SDK 버전
        targetSdk = flutter.targetSdkVersion  // Flutter에서 정의한 타겟 SDK 버전
        versionCode = flutter.versionCode  // Flutter에서 정의한 버전 코드
        versionName = flutter.versionName  // Flutter에서 정의한 버전 이름
    }

    buildTypes {
        release {
            // 릴리즈 빌드의 서명 설정 (현재는 디버그 서명 사용)
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    // Flutter 소스 디렉토리 설정
    source = "../.."
}
