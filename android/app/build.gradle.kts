import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Carrega propriedades de signing do arquivo key.properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "br.com.dcbsys.beatspan"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        manifestPlaceholders += mapOf(
            "redirectSchemeName" to "spotify-sdk",
            "redirectHostName" to "auth"
        )
        applicationId = "br.com.dcbsys.beatspan"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Configuração de signing para release
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            } else {
                // Fallback para debug se key.properties não existir
                // Isso permite que `flutter run --release` funcione sem keystore
                println("⚠️  AVISO: key.properties não encontrado!")
                println("⚠️  Release build será assinado com chaves de DEBUG!")
                println("⚠️  Para produção, execute: android\\setup-keystore.bat")
            }
        }
    }

    buildTypes {
        release {
            // Usa signing config de release se key.properties existir
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                // Fallback para debug (apenas para desenvolvimento)
                signingConfigs.getByName("debug")
            }

            // Otimizações de release
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
