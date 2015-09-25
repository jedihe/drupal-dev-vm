#!/bin/bash

# Taken from baseimage build scripts
#  buildconfig
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
minimal_apt_get_install='apt-get install -y --no-install-recommends'

#  prepare.sh
## Temporarily disable dpkg fsync to make building faster.
echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/02apt-speedup

echo "Running apt-get update"
/usr/bin/apt-get update
$minimal_apt_get_install puppet \
libaugeas-ruby \
augeas-tools \
rubygems

echo "Installing packages"
$minimal_apt_get_install apache2 \
php5 \
php5-imap \
php5-gd \
php5-dev \
php-pear \
php5-curl \
php5-cli \
php5-common \
php5-mysql \
php-apc \
php5-xdebug \
ruby-compass \
ruby-dev \
screen \
mailutils \
php-console-table \
git \
exuberant-ctags \
nfs-common \
puppet \
make \
man \
postfix \
rsync \
libxml-xpath-perl \
unzip \
inotify-tools \
htop \
tmux \
zsh \
memcached \
mysql-server \
mysql-client \
libmemcached-dev \
graphviz \
patch \
wget

# MySQL setup
# Taken from 99_mysql_setup.sh
echo 'Rebuilding mysql data dir'
chown -R mysql.mysql /var/lib/mysql
mysql_install_db > /dev/null
rm -rf /var/run/mysqld/*
echo 'Starting mysqld'
# The sleep 1 is there to make sure that inotifywait starts up before the socket is created
mysqld_safe &
echo 'Waiting for mysqld to come online'
while [ ! -x /var/run/mysqld/mysqld.sock ]; do
    sleep 1
done
echo 'Setting root password to root'
/usr/bin/mysqladmin -u root password 'root'
if [ -d /var/lib/mysql/setup ]; then
    echo 'Found /var/lib/mysql/setup - scanning for SQL scripts'
    for sql in $(ls /var/lib/mysql/setup/*.sql 2>/dev/null | sort); do
        echo 'Running script:' $sql
        mysql -uroot -proot -e "\. $sql"
        mv $sql $sql.processed
    done
else
    echo 'No setup directory with extra sql scripts to run'
fi
echo 'Shutting down mysqld'
mysqladmin -uroot -proot shutdown

$minimal_apt_get_install phpmyadmin

echo "Installing gems"
/usr/bin/gem install -y --include-dependencies --no-rdoc --no-ri compass \
sass \
chunky_png \
fssm \
zurb-foundation

echo "Installing packages from pear/pecl"
/usr/bin/pear install PHP_CodeSniffer-1.5.6
/usr/bin/pear channel-discover pear.drush.org && pear install drush/drush-6.2.0.0
/usr/bin/pecl install -f xhprof-0.9.2
/usr/bin/pecl install -f memcached-2.0.1
/usr/bin/curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
/usr/bin/wget https://phar.phpunit.de/phpunit.phar
/bin/chmod +x phpunit.phar
/bin/mv phpunit.phar /usr/local/bin/phpunit


#  cleanup.sh
echo "Running final clean-up"
apt-get clean
rm -rf /build
rm -rf /tmp/* /var/tmp/*
rm -rf /var/lib/apt/lists/*
rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup

rm -f /etc/ssh/ssh_host_*
