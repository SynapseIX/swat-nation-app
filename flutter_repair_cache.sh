#!/bin/bash

echo Cleaning project...
flutter clean 2>&1 >/dev/null

echo Cleaning Gradle build cache...
cd android
./gradlew --stop 2>&1 >/dev/null
rm -rf ~/.gradle/caches/ 2>&1 >/dev/null
./gradlew cleanBuildCache 2>&1 >/dev/null
cd ..

echo Updating Pod...
pod repo update 2>&1 >/dev/null

echo Removing pod files...
cd ios
rm -rf Podfile.lock Pods/ 2>&1 >/dev/null
cd ..

echo Removing cached flutter dependency files...
rm -rf pubspec.lock .packages .flutter-plugins 2>&1 >/dev/null

echo Repairing pub cache...
flutter pub pub cache repair 2>&1 >/dev/null

echo Getting all flutter packages...
flutter packages get 2>&1 >/dev/null

echo Running pod install...
cd ios
pod install 2>&1 >/dev/null
cd ..

echo DONE!
