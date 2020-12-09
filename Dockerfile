FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
    apt-utils \
    curl \
    zip \
    unzip \    
    # Install apache
    apache2 \
    # Install php 7.2
    libapache2-mod-php7.4 \
    php7.4-cli \
    php7.4-json \
    php7.4-curl \
    php7.4-fpm \
    php7.4-gd \
    php7.4-ldap \
    php7.4-mbstring \
    php7.4-mysql \
    php7.4-soap \
    php7.4-sqlite3 \
    php7.4-xml \
    php7.4-zip \
    php7.4-intl \
    php-imagick \
    # Install tools
    openssl \
    nano \
    graphicsmagick \
    imagemagick \
    ghostscript \
    iputils-ping \
    locales \
    ca-certificates \
    php-yaml \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set locales
RUN locale-gen en_US.UTF-8 en_GB.UTF-8 de_DE.UTF-8 es_ES.UTF-8 fr_FR.UTF-8 it_IT.UTF-8 km_KH sv_SE.UTF-8 fi_FI.UTF-8
# Configure PHP for TYPO3
COPY typo3.ini /etc/php/7.2/mods-available/
RUN phpenmod typo3
# Configure apache for TYPO3
RUN a2enmod rewrite expires
RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf
RUN a2enconf servername
# Configure vhost for TYPO3
COPY typo3.conf /etc/apache2/sites-available/
RUN a2dissite 000-default
RUN a2ensite typo3.conf
# Heure et date
RUN echo "Europe/Paris" > /etc/timezone
RUN cp /usr/share/zoneinfo/Europe/Paris /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata
# Suppression du répertoire html
RUN rm -rf /var/www/html 

EXPOSE 80 443

WORKDIR /var/www/

CMD apachectl -D FOREGROUND 
