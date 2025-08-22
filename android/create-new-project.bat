@echo off
echo Creating a new Flutter project and migrating code from the existing project...

:: Step 1: Create a new Flutter project
echo Step 1: Creating a new Flutter project...
cd ..
mkdir wayli-new
cd wayli-new
flutter create --org com.example --project-name wayli .

:: Step 2: Copy the lib directory
echo Step 2: Copying the lib directory...
xcopy /E /I /Y ..\way-li\lib lib

:: Step 3: Copy the assets directory
echo Step 3: Copying the assets directory...
xcopy /E /I /Y ..\way-li\assets assets

:: Step 4: Copy the pubspec.yaml and update dependencies
echo Step 4: Copying and updating pubspec.yaml...
copy ..\way-li\pubspec.yaml pubspec.yaml

:: Step 5: Update the Android configuration
echo Step 5: Updating Android configuration...
:: Copy any custom configurations from the old project
if exist ..\way-li\android\app\src\main\AndroidManifest.xml (
    copy ..\way-li\android\app\src\main\AndroidManifest.xml android\app\src\main\AndroidManifest.xml
)

:: Step 6: Install dependencies
echo Step 6: Installing dependencies...
flutter pub get

echo Done! The new project has been created in the wayli-new directory.
echo Please review the new project and make any necessary adjustments.
echo To build the new project, run: cd wayli-new && flutter build apk --release