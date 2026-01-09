#!/bin/bash
# Android Emulator Setup Script for GitHub Codespaces
# هذا السكربت يثبت محاكي أندرويد مع noVNC

set -e

echo "🤖 جاري تثبيت محاكي أندرويد..."

# Update system
sudo apt-get update

# Install required packages
sudo apt-get install -y \
    wget \
    curl \
    unzip \
    openjdk-17-jdk \
    libgl1-mesa-glx \
    libpulse0 \
    libnss3 \
    libxcomposite1 \
    libxcursor1 \
    libxi6 \
    libxtst6 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients

# Set JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" >> ~/.bashrc

# Download Android Command Line Tools
ANDROID_SDK_ROOT=/opt/android-sdk
sudo mkdir -p $ANDROID_SDK_ROOT
cd /tmp

echo "📥 جاري تحميل أدوات أندرويد..."
wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O cmdline-tools.zip
sudo unzip -q cmdline-tools.zip -d $ANDROID_SDK_ROOT
sudo mv $ANDROID_SDK_ROOT/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools-temp
sudo mkdir -p $ANDROID_SDK_ROOT/cmdline-tools
sudo mv $ANDROID_SDK_ROOT/cmdline-tools-temp $ANDROID_SDK_ROOT/cmdline-tools/latest

# Set Android SDK environment variables
export ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator

echo "export ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT" >> ~/.bashrc
echo "export PATH=\$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator" >> ~/.bashrc

# Accept licenses
echo "📝 جاري قبول التراخيص..."
yes | sudo $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager --licenses || true

# Install Android SDK components
echo "📦 جاري تثبيت مكونات SDK..."
sudo $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager \
    "platform-tools" \
    "platforms;android-33" \
    "system-images;android-33;google_apis;x86_64" \
    "emulator"

# Create AVD (Android Virtual Device)
echo "📱 جاري إنشاء جهاز افتراضي..."
echo "no" | sudo $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/avdmanager create avd \
    -n "android_emulator" \
    -k "system-images;android-33;google_apis;x86_64" \
    -d "pixel_4" \
    --force

# Set permissions
sudo chmod -R 777 $ANDROID_SDK_ROOT

# Create start script
cat > ~/start-android.sh << 'SCRIPT'
#!/bin/bash
echo "🚀 جاري تشغيل محاكي أندرويد..."
echo "💡 افتح المتصفح على البورت 6080 للوصول للمحاكي"

# Start emulator with GPU disabled for cloud environment
export DISPLAY=:1
/opt/android-sdk/emulator/emulator \
    -avd android_emulator \
    -no-audio \
    -gpu swiftshader_indirect \
    -no-boot-anim \
    -memory 2048 \
    -cores 2 \
    -no-snapshot \
    -wipe-data &

echo "✅ المحاكي يعمل الآن!"
echo "🌐 افتح: http://localhost:6080"
SCRIPT

chmod +x ~/start-android.sh

echo ""
echo "✅ تم التثبيت بنجاح!"
echo ""
echo "📌 لتشغيل المحاكي:"
echo "   bash ~/start-android.sh"
echo ""
echo "🌐 ثم افتح المتصفح على البورت 6080"
echo ""
