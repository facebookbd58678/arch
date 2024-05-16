ARG VERSION

FROM archlinux:${VERSION:-latest}
LABEL MAINTAINER="DCsunset"

ENV noVNC_version=1.2.0
ENV websockify_version=0.9.0

# Install base-devel for building AUR packages
RUN pacman -Syu --noconfirm base-devel

# Install yay for AUR packages
RUN git clone https://aur.archlinux.org/yay.git /tmp/yay \
    && cd /tmp/yay \
    && makepkg -si --noconfirm \
    && cd / \
    && rm -rf /tmp/yay

# Install apps for engineers, artists, media, accessories, system monitoring, GTK development, and AUR
RUN yay -Syu --noconfirm plasma-meta \
	kde-accessibility-meta kde-system-meta konsole \
	chromium vim wget tigervnc xorg-server \
	python-numpy python-setuptools \
	git code atom gcc gtk rustup neofetch sudo nodejs npm curl wget nano php \
    libreoffice-fresh \
    flameshot \
    simplescreenrecorder \
    gimp \
    blender \
    audacity \
    inkscape \
    krita \
    mypaint \
    darktable \
    vlc \
    shotcut \
    obs-studio \
    ark \
    dolphin \
    okular \
    htop \
    iotop \
    lm_sensors \
    gtk3 \
    gtkmm \
    && pacman -Scc --noconfirm

# Install additional utilities
RUN pacman -Syu --noconfirm iputils iproute2 openssh rsync unzip zip tar \
    && pacman -Scc --noconfirm

# Install noVNC
RUN	wget https://github.com/novnc/websockify/archive/v${websockify_version}.tar.gz -O /websockify.tar.gz \
	&& tar -xvf /websockify.tar.gz -C / \
	&& cd /websockify-${websockify_version} \
	&& python setup.py install \
	&& cd / && rm -r /websockify.tar.gz /websockify-${websockify_version} \
	&& wget https://github.com/novnc/noVNC/archive/v${noVNC_version}.tar.gz -O /noVNC.tar.gz \
	&& tar -xvf /noVNC.tar.gz -C / \
	&& cd /noVNC-${noVNC_version} \
	&& ln -s vnc.html index.html \
	&& rm /noVNC.tar.gz

COPY ./config/xstartup /root/.vnc/
COPY ./start.sh /

WORKDIR /root

EXPOSE 5900 6080

CMD [ "/start.sh" ]
