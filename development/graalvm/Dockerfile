FROM ubuntu:bionic
MAINTAINER Chris Grant <chrisgrant.datascience@gmail.com>

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils wget curl ca-certificates apt-transport-https ca-certificates \
                                               dirmngr gnupg software-properties-common gcc zlib1g-dev build-essential \
                                               unzip git java-common gfortran gcc g++ && \
    cd /opt && \
    wget --quiet https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-20.1.0/graalvm-ce-java8-linux-amd64-20.1.0.tar.gz && \
    git clone https://github.com/chrishantha/install-java && \
    yes | ./install-java/install-java.sh -f graalvm-ce-java8-linux-amd64-20.1.0.tar.gz && \
    source ~/.bashrc && \
    rm graalvm-ce-java8-linux-amd64-20.1.0.tar.gz && \
    apt-get clean && \
  	rm -rf /var/lib/apt/lists/*

##    tar -xzf graalvm-ce-java8-linux-amd64-20.1.0.tar.gz
##    update-alternatives --install java graalvm-ce-java8-20.1.0
#    cd /opt && \
#    git clone https://github.com/apache/arrow.git && \







#
#
#      adwaita-icon-theme at-spi2-core ca-certificates-java fontconfig fontconfig-config fonts-dejavu-core fonts-dejavu-extra gtk-update-icon-cache hicolor-icon-theme humanity-icon-theme krb5-locales libasyncns0 libatk-bridge2.0-0 libatk-wrapper-java
#      libatk-wrapper-java-jni libatk1.0-0 libatk1.0-data libatspi2.0-0 libavahi-client3 libavahi-common-data libavahi-common3 libcairo2 libcroco3 libcups2 libdatrie1 libdrm-amdgpu1 libdrm-common libdrm-intel1 libdrm-nouveau2 libdrm-radeon1 libdrm2 libedit2 libelf1
#      libflac8 libfontconfig1 libfontenc1 libfreetype6 libgail-common libgail18 libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-bin libgdk-pixbuf2.0-common libgif7 libgl1 libgl1-mesa-dri libgl1-mesa-glx libglapi-mesa libglvnd0 libglx-mesa0 libglx0 libgraphite2-3 libgssapi-krb5-2
#      libgtk2.0-0 libgtk2.0-bin libgtk2.0-common libharfbuzz0b libice-dev libice6 libjbig0 libjpeg-turbo8 libjpeg8 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libllvm10 libnspr4 libnss3 libogg0 libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0
#      libpciaccess0 libpcsclite1 libpixman-1-0 libpng16-16 libpthread-stubs0-dev libpulse0 librsvg2-2 librsvg2-common libsensors4 libsm-dev libsm6 libsndfile1 libthai-data libthai0 libtiff5 libvorbis0a libvorbisenc2 libwrap0 libx11-dev libx11-doc libx11-xcb1
#      libxau-dev libxaw7 libxcb-dri2-0 libxcb-dri3-0 libxcb-glx0 libxcb-present0 libxcb-render0 libxcb-shape0 libxcb-shm0 libxcb-sync1 libxcb1-dev libxcomposite1 libxcursor1 libxdamage1 libxdmcp-dev libxfixes3 libxft2 libxinerama1 libxmu6 libxmuu1 libxpm4 libxrandr2
#      libxshmfence1 libxt-dev libxt6 libxv1 libxxf86dga1 libxxf86vm1 openjdk-8-jdk openjdk-8-jdk-headless openjdk-8-jre openjdk-8-jre-headless ubuntu-mono x11-utils x11proto-core-dev x11proto-dev xorg-sgml-doctools xtrans-dev
