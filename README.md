# VLC-ANDROID-SDK

[![Build Status](https://travis-ci.com/maximilize/vlc-android-sdk.svg?branch=master)](https://travis-ci.com/maximilize/vlc-android-sdk)

### libvlc for android based on VLC-Android 3.2.11

# Setup

### Add the JitPack repository to your root build.gradle

```gradle
allprojects {
    repositories {
        ...
        maven { url 'https://jitpack.io' }
    }
}
```

### Add the vlc-android-sdk dependency

```gradle
dependencies {
    implementation 'com.github.maximilize:vlc-android-sdk:4.1.0'
}
```
