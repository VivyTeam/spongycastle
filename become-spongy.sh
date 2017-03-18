#!/bin/bash 

# Package rename org.bouncycastle to org.spongycastle
    
find -name bouncycastle | xargs rename s/bouncycastle/spongycastle/

find {core,jce,prov,pg,pkix} -type f | xargs -I '{}' ssed -i -R 's/bouncycastle(?!.org)/spongycastle/g' '{}'

# find bc* -type f | xargs sed -i s/bouncycastle/spongycastle/g

# BC to SC for provider name
    
find {core,jce,prov,pg,pkix} -type f | xargs -I '{}' sed -i s/\"BC\"/\"SC\"/g '{}'

# Rename 'bc' artifacts to 'sc'
    
# rename s/^bc/sc/ *
# find -name 'pom.xml' | xargs sed -i s/\>bc/\>sc/g

# Rename maven artifact 'names' to use Spongy rather than Bouncy

# find -name 'pom.xml' | xargs sed -i s/\>Bouncy/\>Spongy/g



#### modifications for mail package###
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
    compileSdkVersion 24
    buildToolsVersion "24.0.0"

    defaultConfig {
        minSdkVersion 15
        targetSdkVersion 24
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
    
sed -i 's~new SerialisationTest()~// new SerialisationTest() // Attempts to deserialise a org.bouncycastle class~g' prov/src/test/jdk1.4/org/spongycastle/jce/provider/test/RegressionTest.java
sed -i 's~new SerialisationTest(),~// new SerialisationTest(), // Attempts to deserialise a org.bouncycastle class~g' prov/src/test/java/org/spongycastle/jce/provider/test/RegressionTest.java

sed -i 's/"SC", /"BC", /g' prov/src/main/java/org/spongycastle/jce/provider/BouncyCastleProvider.java

cat <<EOF >> .gitignore 
.idea
*.iml
*.asc

pg/*.asc
EOF