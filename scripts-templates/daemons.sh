# install postgres, redis, memcached, and supervisor
sudo cp -r ~/files/daemons/dotdeb.org.list /etc/apt/sources.list.d/dotdeb.org.list
wget -q -O - http://www.dotdeb.org/dotdeb.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql postgresql-contrib libpq-dev redis-server memcached supervisor

# set up supervisor daemons
sudo groupadd supervisor
sudo adduser deploy supervisor

sudo cp ~/files/daemons/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
sudo cp ~/files/daemons/supervisor/scoryst.conf /etc/supervisor/conf.d/scoryst.conf
sudo cp ~/files/daemons/supervisor/scoryst-celery-worker.conf \
  /etc/supervisor/conf.d/scoryst-celery-worker.conf
