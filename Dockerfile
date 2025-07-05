# 1. Base image with Flutter SDK
FROM cirrusci/flutter:stable

# 2. Install Android SDK + JDK for future APK builds (optional)
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk curl unzip git && \
    curl -O https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    mkdir -p /opt/android-sdk/cmdline-tools && \
    unzip commandlinetools-linux-*.zip -d /opt/android-sdk/cmdline-tools && \
    mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest && \
    yes | /opt/android-sdk/cmdline-tools/latest/bin/sdkmanager --licenses && \
    /opt/android-sdk/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-33"

ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin

# 3. Copy code
WORKDIR /app
COPY . .

# 4. Install Node dependencies
RUN apt-get install -y nodejs npm && \
    npm install express cors body-parser

# 5. Expose port and run
EXPOSE 8080
CMD ["node", "server.js"]
