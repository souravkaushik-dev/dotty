import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties
val keystoreProperties = Properties()

val keystorePropertiesFile =
    rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(
        FileInputStream(
            keystorePropertiesFile
        )
    )
}
android {
    namespace = "com.studios.dotty"
    compileSdk = 36
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.studios.dotty"
        minSdk = 24
        targetSdk = 36
        versionCode =
            flutter.versionCode
        versionName =
            flutter.versionName
    }

    signingConfigs {

        create("release") {

            keyAlias =
                keystoreProperties["keyAlias"]?.toString()

            keyPassword =
                keystoreProperties["keyPassword"]?.toString()

            storeFile =
                keystoreProperties["storeFile"]
                    ?.toString()
                    ?.let { path ->
                        file(path)
                    }

            storePassword =
                keystoreProperties["storePassword"]?.toString()
        }
    }
    buildTypes {

        getByName("release") {

            signingConfig =
                signingConfigs.getByName("release")

            isMinifyEnabled = false

            isShrinkResources = false

            proguardFiles(
                getDefaultProguardFile(
                    "proguard-android-optimize.txt"
                ),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
