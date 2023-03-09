FROM public.ecr.aws/lambda/python:3.10 as build
RUN yum install -y unzip && \
    curl -Lo "/tmp/chromedriver.zip" "https://chromedriver.storage.googleapis.com/111.0.5563.64/chromedriver_linux64.zip" && \
    curl -Lo "/tmp/chrome-linux.zip" "https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F1097615%2Fchrome-linux.zip?alt=media" && \
    unzip /tmp/chromedriver.zip -d /opt/ && \
    unzip /tmp/chrome-linux.zip -d /opt/

FROM public.ecr.aws/lambda/python:3.10

# Main dependencies
RUN yum install -y atk cups-libs gtk3 libXcomposite alsa-lib \
    libXcursor libXdamage libXext libXi libXrandr libXScrnSaver \
    libXtst pango at-spi2-atk libXt xorg-x11-server-Xvfb \
    xorg-x11-xauth dbus-glib dbus-glib-devel -y

RUN yum install -y \
    cjkuni-ukai-fonts.noarch \
    cjkuni-uming-fonts.noarch \
    google-noto-sans-cjk-fonts.noarch \
    texlive-cjk.noarch \
    texlive-cjk-doc.noarch \
    texlive-cjk-doc.noarch \
    texlive-xecjk.noarch  \
    texlive-xecjk-doc.noarch \
    man-pages-zh-CN.noarch \
    ghostscript-chinese-zh_CN.noarch \
    ghostscript-chinese-zh_TW.noarch \
    glibc-langpack-lzh.x86_64 \
    glibc-langpack-zh.x86_64 \
    ghostscript-chinese.noarch \       
    ghostscript-chinese-zh_CN.noarch  \
    ghostscript-chinese-zh_TW.noarch   \
    google-noto-sans-simplified-chinese-fonts.noarch \
    google-noto-sans-traditional-chinese-fonts.noarch \
    ibus-table-chinese.noarch \
    ibus-table-chinese-array.noarch     \   
    ibus-table-chinese-cangjie.noarch    \
    ibus-table-chinese-cantonese.noarch  \
    ibus-table-chinese-easy.noarch \
    ibus-table-chinese-erbi.noarch \
    ibus-table-chinese-quick.noarch \ 
    ibus-table-chinese-scj.noarch \
    ibus-table-chinese-stroke5.noarch  \ 
    ibus-table-chinese-wu.noarch \
    ibus-table-chinese-wubi-haifeng.noarch \
    ibus-table-chinese-wubi-jidian.noarch \
    ibus-table-chinese-yong.noarch 

RUN yum install -y sudo

RUN yum install -y yum install ibasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget

RUN yum install -y amazon-linux-extras

RUN sudo amazon-linux-extras install epel -y

RUN yum install -y curl cabextract xorg-x11-font-utils fontconfig && \
    yum install -y https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

RUN yum reinstall -y glibc-common

RUN fc-cache -fv

RUN pip install selenium

COPY --from=build /opt/chrome-linux /opt/chrome
COPY --from=build /opt/chromedriver /opt/
COPY main.py ./

CMD [ "main.handler" ]