#!/bin/bash
# Installs essential apps for the Android Emulator

echo "Downloading Essential Apps..."

mkdir -p /tmp/apps
cd /tmp/apps

# 1. Messenger (Example of a useful app, using direct link if available, or just Aurora Store)
# Let's stick to Aurora Store for app installation and a Browser.

echo "Downloading Aurora Store (Google Play Alternative)..."
wget -q https://f-droid.org/repo/com.aurora.store_42.apk -O aurora.apk

echo "Downloading Kiwi Browser (Chrome + Extensions)..."
wget -q https://github.com/kiwibrowser/src.next/releases/download/trilinos-source/Kiwi-20230523-Classic.apk -O kiwi.apk

echo "Installing Apps..."
adb install aurora.apk
adb install kiwi.apk

echo "App Installation Complete!"
echo "You can now open Aurora Store to download any app you want."
