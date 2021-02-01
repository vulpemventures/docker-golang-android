FROM ghcr.io/vulpemventures/golang:1.15.7-ubuntu20.04

# Configure timezone
ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#Modified from https://github.com/getlantern/gomobile-docker
RUN apt-get update && apt-get install -y build-essential curl git apt-utils openjdk-8-jdk curl wget unzip file pkg-config lsof libpcap-dev

WORKDIR /gomobile

# Environment variables
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV GRADLE_HOME /usr/local/gradle
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools
ENV PATH $PATH:$ANDROID_HOME/ndk-bundle
ENV PATH $PATH:/usr/local/gradle/bin


ENV ANDROID_HOME /usr/local/android-sdk-tools
ENV ANDROID_BIN /usr/local/android-sdk-tools/tools/bin

# Get the latest version from https://developer.android.com/studio/index.html
ENV ANDROID_SDK_TOOLS_VERSION="4333796"

# Get the latest version from https://developer.android.com/ndk/downloads/index.html
ENV ANDROID_NDK_VERSION="r21c"

# Install Android SDK
RUN echo "Installing sdk tools ${ANDROID_SDK_TOOLS_VERSION}" && \
  wget --quiet --output-document=sdk-tools.zip \
  "https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip" && \
  mkdir --parents "$ANDROID_HOME" && \
  unzip -q sdk-tools.zip -d "$ANDROID_HOME" && \
  rm --force sdk-tools.zip

# Install Android tools
RUN yes | $ANDROID_BIN/sdkmanager --licenses
RUN yes | $ANDROID_BIN/sdkmanager tools
RUN yes | $ANDROID_BIN/sdkmanager platform-tools
RUN yes | $ANDROID_BIN/sdkmanager ndk-bundle
RUN $ANDROID_BIN/sdkmanager platforms\;android-28

# Install Gradle
ENV GRADLE_VERSION 6.4.1
RUN cd /usr/local/ && \
  wget https://downloads.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip && \
  unzip gradle-$GRADLE_VERSION-bin.zip && \
  mv gradle-$GRADLE_VERSION gradle && \
  rm gradle-$GRADLE_VERSION-bin.zip

# Install gomobile
RUN go get golang.org/x/mobile/cmd/gomobile
RUN go get golang.org/x/mobile/cmd/gobind
RUN go install golang.org/x/mobile/cmd/gomobile
RUN go install golang.org/x/mobile/cmd/gobind