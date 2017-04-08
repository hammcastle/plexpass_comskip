FROM plexinc/pms-docker:plexpass
LABEL org.freenas.interactive="false" 		\
      org.freenas.version="Latest (Auto Update)"		\
      org.freenas.upgradeable="true"		\
      org.freenas.expose-ports-at-host="true"	\
      org.freenas.autostart="true"		\
      org.freenas.capabilities-add="NET_BROADCAST" \
      org.freenas.web-ui-protocol="http"	\
      org.freenas.web-ui-port=32400		\
      org.freenas.web-ui-path="web"		\
      org.freenas.port-mappings="32400:32400/tcp,3005:3005/tcp,8324:8324/tcp,32469:32469/tcp,1900:1900/udp,32410:32410/udp,32412:32412/udp,32413:32413/udp,32414:32414/udp"			\
      org.freenas.volumes="[					\
          {							\
              \"name\": \"/config\",				\
              \"descr\": \"Config storage space\"		\
          },							\
          {							\
              \"name\": \"/transcode\",				\
              \"descr\": \"Video transcode directory\"		\
          },							\
          {							\
              \"name\": \"/data\",				\
              \"descr\": \"Media volume\"			\
          }							\
      ]"							\
      org.freenas.settings="[ 					\
          {							\
              \"env\": \"TZ\",					\
              \"descr\": \"Plex container Timezone\",		\
              \"optional\": true				\
          },							\
          {							\
              \"env\": \"ADVERTISE_IP\",			\
              \"descr\": \"http://<hostIPAddress>:32400/\",	\
              \"optional\": true				\
          },							\
          {							\
              \"env\": \"ALLOWED_NETWORKS\",			\
              \"descr\": \"IP/mask[,IP/mask]\",			\
              \"optional\": true				\
          },							\
          {							\
              \"env\": \"PLEX_UID\",				\
              \"descr\": \"Plex User ID\",			\
              \"optional\": true				\
          },							\
          {							\
              \"env\": \"PLEX_GID\",				\
              \"descr\": \"Plex Group ID\",			\
              \"optional\": true				\
          },							\
          {							\
              \"env\": \"PLEX_CLAIM\",				\
              \"descr\": \"Plex Account Token\",		\
              \"optional\": true				\
          } 							\
      ]"

RUN \
    apt-get update && apt-get -y dist-upgrade && \
    
    apt-get install -y \
      build-essential \
      git \
      libargtable2-dev \
      libsdl1.2-dev \
      autoconf \
      libtool \
      libavutil-dev \
      libavformat-dev \
      libavcodec-dev \
      ffmpeg \
      mkvtoolnix \
    && \
    mkdir -p /plexbin && \
    
    git clone https://github.com/erikkaashoek/Comskip.git && \
    git clone https://github.com/ekim1337/PlexComskip.git && \
    cd /Comskip && ./autogen.sh && ./configure && make && make install && \
    cp comskip /plexbin && \
    cd /PlexComskip && cp comskip.ini PlexComskip.py /plexbin && cp PlexComskip.conf.example /plexbin/PlexComskip.conf && \
    cp `which ffmpeg` /plexbin && \
    cp `which mkvpropedit` /plexbin

VOLUME /plexbin
