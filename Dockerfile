FROM ubuntu
ENV NETATALK_VERSION 3.1.11

ENV DEPS="build-essential libevent-dev libssl-dev libgcrypt11-dev libkrb5-dev libpam0g-dev libwrap0-dev libdb-dev libtdb-dev libmysqlclient-dev libavahi-client-dev libacl1-dev libldap2-dev libcrack2-dev systemtap-sdt-dev libdbus-1-dev libdbus-glib-1-dev libglib2.0-dev libtracker-sparql-1.0-dev libtracker-miner-1.0-dev file"
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get install \
        --no-install-recommends \
        --fix-missing \
        --assume-yes \
        $DEPS \
        tracker \
        avahi-daemon \
        curl wget \
        &&  wget      "http://ufpr.dl.sourceforge.net/project/netatalk/netatalk/3.1.11/netatalk-3.1.11.tar.gz" \
        &&  curl -SL  "http://ufpr.dl.sourceforge.net/project/netatalk/netatalk/3.1.11/netatalk-3.1.11.tar.gz" | tar xvz

RUN apt-get install \
	--assume-yes \
        --fix-missing \
	krb5-user libpam-krb5 tzdata vim

WORKDIR netatalk-3.1.11

RUN ./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --with-init-style=debian-systemd \
        --without-libevent \
        --without-tdb \
        --with-cracklib \
        --enable-krbV-uam \
        --with-pam-confdir=/etc/pam.d \
        --with-dbus-sysconf-dir=/etc/dbus-1/system.d \
        --with-tracker-pkgconfig-version=1.0 \
        &&  make \
         &&  make install \
          &&  apt-get --quiet --yes purge --auto-remove \
        $DEPS \
        tracker-gui \
        libgl1-mesa-dri \
        &&  DEBIAN_FRONTEND=noninteractive apt-get install --yes \
        libevent-2.0 \
        libavahi-client3 \
        libevent-core-2.0 \
        libwrap0 \
        libtdb1 \
        libmysqlclient20 \
        libcrack2 \
        libdbus-glib-1-2 \
        &&  apt-get --quiet --yes autoclean \
         &&  apt-get --quiet --yes autoremove \
          &&  apt-get --quiet --yes clean \
           &&  rm -rf /netatalk* \
            &&  rm -rf /usr/share/man \
             &&  rm -rf /usr/share/doc \
              &&  rm -rf /usr/share/icons \
               &&  rm -rf /usr/share/poppler \
                &&  rm -rf /usr/share/mime \
                 &&  rm -rf /usr/share/GeoIP \
                  &&  rm -rf /var/lib/apt/lists* \
                   &&  mkdir /media/share

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY afp.conf /etc/afp.conf
COPY krb5.conf /etc/krb5.conf
RUN rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime 

CMD ["/docker-entrypoint.sh"]
