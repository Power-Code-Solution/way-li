@echo off
echo Fixing Gradle wrapper issues...

echo Deleting .gradle directory...
rmdir /s /q .gradle

echo Deleting Gradle wrapper cache...
rmdir /s /q %USERPROFILE%\.gradle\wrapper\dists\gradle-8.4-bin

echo Backing up original wrapper files...
if exist gradlew.bat.bak del gradlew.bat.bak
if exist gradlew.bak del gradlew.bak
copy gradlew.bat gradlew.bat.bak
copy gradlew gradlew.bak

echo Downloading a fresh copy of Gradle...
:: Use a direct download of a small Gradle version to bootstrap
curl -L -o gradle-wrapper.zip https://services.gradle.org/distributions/gradle-8.4-bin.zip
if not exist gradle\wrapper mkdir gradle\wrapper
move gradle-wrapper.zip gradle\wrapper\gradle-wrapper.zip

echo Regenerating Gradle wrapper...
:: Use the downloaded Gradle to regenerate the wrapper
call gradlew.bat wrapper --gradle-version 8.4 --distribution-type bin

echo Done! Try building your app again with:
echo flutter build apk --release
