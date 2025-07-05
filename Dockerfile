FROM cirrusci/flutter:stable

# Install Android SDK + JDK
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk curl unzip git nodejs npm && \
    curl -O https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    mkdir -p /opt/android-sdk/cmdline-tools && \
    unzip commandlinetools-linux-*.zip -d /opt/android-sdk/cmdline-tools && \
    mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest && \
    yes | /opt/android-sdk/cmdline-tools/latest/bin/sdkmanager --licenses && \
    /opt/android-sdk/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-33" && \
    rm commandlinetools-linux-*.zip

ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 8080
CMD ["node", "server.js"]
