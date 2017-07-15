FROM ubuntu:14.04
ENV ENVIRONMENT docker
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

RUN apt-get update && \
    apt-get install -y software-properties-common --no-install-recommends
    
RUN add-apt-repository -y ppa:ondrej/php && \
    apt-get update -y --force-yes && \
    apt-get install -y --force-yes --no-install-recommends \ 
      git \
      mercurial \
      nano \
      apache2 \
      php5.6 \
      php5.6-cli \
      php5.6-common \
      php5.6-opcache \
      libapache2-mod-php5.6 \
      php5.6-gd \
      php5.6-json \
      php5.6-ldap \
      php5.6-mysql \
      php5.6-pgsql \
      php5.6-sqlite \
      php5.6-mbstring \
      php5.6-apc \
      php5.6-curl \
      php5.6-xml \
      php5.6-xdebug \
      php5.6-bcmath \
      php5.6-intl \
      php5.6-mcrypt \
      php5.6-zip \
      curl lynx-cur

RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/5.6/apache2/php.ini

RUN cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN echo "xdebug.remote_enable=on" >> /etc/php/5.6/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /etc/php/5.6/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /etc/php/5.6/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.remote_port=${XDEBUG_REMOTE_PORT}" >> /etc/php/5.6/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.idekey=${XDEBUG_IDEKEY}" >> /etc/php/5.6/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.max_nesting_level=${XDEBUG_MAX_NESTING_LEVEL}" >> /etc/php/5.6/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.remote_connect_back=off" >> /etc/php/5.6/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.remote_host=${XDEBUG_IP_ADDRESS}" >> /etc/php/5.6/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.remote_log=${XDEBUG_REMOTE_LOG}" >> /etc/php/5.6/cli/conf.d/20-xdebug.ini

RUN a2enmod rewrite
RUN export XDEBUG_CONFIG="remote_enable=on remote_autostart=off remote_handler=dbgp remote_connect_back=off remote_port=${XDEBUG_REMOTE_PORT} show_local_vars=on max_nesting_level=${XDEBUG_MAX_NESTING_LEVEL} remote_log=${XDEBUG_REMOTE_LOG} remote_host=${XDEBUG_IP_ADDRESS} xdebug.idekey=${XDEBUG_IDEKEY}"
CMD ["apache2ctl", "start"]
