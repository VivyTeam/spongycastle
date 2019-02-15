cat <<EOF > mail/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.spongycastle">
</manifest>
EOF

cat <<EOF > mail/build.gradle
apply plugin: 'com.android.library'
dependencies {
    compile 'com.sun.mail:android-mail:1.5.5'
    compile 'com.sun.mail:android:1.5.5'
    compile 'com.madgag.spongycastle:pkix:1.54.0.0'
    compile 'com.madgag.spongycastle:prov:1.54.0.0'
    compile 'com.madgag.spongycastle:core:1.54.0.0'
    testCompile 'junit:junit:4.12'
}

android {
    compileSdkVersion 28
    buildToolsVersion "28"

    defaultConfig {
        minSdkVersion 15
        targetSdkVersion 28
        versionCode 1
        versionName "1.0"
    }
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
EOF

find "mail/src/main/java/org/spongycastle/mail/smime/handlers" -type f | xargs -I '{}' ssed -i 's/ DataFlavor/ ActivationDataFlavor/g' '{}'
find "mail/src/main/java/org/spongycastle/mail/smime/handlers" -type f | xargs -I '{}' ssed -i 's/(DataFlavor/(ActivationDataFlavor/g' '{}'

find "mail/src/main/java/org/spongycastle/mail/smime/handlers" -type f | xargs -I '{}' ssed -i 's/import java.awt.datatransfer.DataFlavor;//g' '{}'