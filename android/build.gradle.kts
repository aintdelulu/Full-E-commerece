apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'

android {
    namespace "com.example.flutter_application_1"
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.example.flutter_application_1"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        multiDexEnabled true
    }

    buildTypes {
        release {
            shrinkResources false
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = '17'
    }

    packagingOptions {
        exclude 'META-INF/AL2.0'
        exclude 'META-INF/LGPL2.1'
    }
}

flutter {
    source '../..'
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib:1.9.22"
    implementation 'androidx.multidex:multidex:2.0.1'
}
