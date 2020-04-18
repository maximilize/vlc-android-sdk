FROM debian:stretch-20200414

ENV USERNAME="ci"
ENV ANDROID_SDK=/home/"$USERNAME"/android-sdk
ENV ANDROID_NDK=/home/"$USERNAME"/android-ndk

RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends -y \
    openjdk-8-jdk-headless ca-certificates autoconf m4 automake ant autopoint bison \
    flex build-essential libtool libtool-bin patch pkg-config ragel subversion \
    git rpm2cpio libwebkitgtk-1.0-0 yasm ragel g++ protobuf-compiler gettext \
    libgsm1-dev wget expect unzip zip python python3 locales libltdl-dev \
    cmake \
    automake && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    addgroup --quiet "$USERNAME" && \
    adduser --quiet --disabled-password -gecos "" --ingroup "$USERNAME" "$USERNAME" && \
    echo "$USERNAME:$USERNAME" | chpasswd

USER "$USERNAME"
RUN mkdir -p "$ANDROID_SDK" && cd "$ANDROID_SDK" && \
    mkdir licenses && \
    echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "licenses/android-sdk-license" && \
    echo "d56f5187479451eabf01fb78af6dfcb131a6481e" >> "licenses/android-sdk-license" && \
    wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
    SDK_TOOLS_SHA256=444e22ce8ca0f67353bda4b85175ed3731cae3ffa695ca18119cbacef1c1bea0 && \
    echo "$SDK_TOOLS_SHA256" sdk-tools-linux-3859397.zip | sha256sum -c && \
    unzip sdk-tools-linux-3859397.zip && \
    rm -f sdk-tools-linux-3859397.zip && \
    tools/bin/sdkmanager "build-tools;26.0.1" "platform-tools" "platforms;android-26" && \
    mkdir -p "$ANDROID_NDK" && cd "$ANDROID_NDK" && \
    wget https://dl.google.com/android/repository/android-ndk-r18b-linux-x86_64.zip && \
    ANDROID_NDK_SHA1=500679655da3a86aecf67007e8ab230ea9b4dd7b && \
    echo "$ANDROID_NDK_SHA1" android-ndk-r18b-linux-x86_64.zip | sha1sum -c && \
    unzip android-ndk-r18b-linux-x86_64.zip && \
    rm -f android-ndk-r18b-linux-x86_64.zip && \
    mv android-ndk-r18b/** . && \
    rm -rf android-ndk-r18b && \
    git config --global user.name "$USERNAME" && \
    git config --global user.email "$USERNAME@ci.com"

COPY compile-jni /home/"$USERNAME"/
ENTRYPOINT ["/home/ci/compile-jni"]
