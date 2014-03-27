# install dependencies
sudo apt-get -y install vim git python python-pip python-dev
sudo pip install virtualenv

# set up SSH deploy key
sudo cp ~/files/scoryst/deploy-key/* /home/deploy/.ssh
sudo chmod 600 /home/deploy/.ssh/id_rsa
sudo chmod 644 /home/deploy/.ssh/id_rsa.pub

# fetch latest Scoryst code from git
sudo cp ~/files/scoryst/ssh_config /home/deploy/.ssh/config
sudo chmod 644 /home/deploy/.ssh/config

sudo chown deploy:deploy /home/deploy -R
sudo su - deploy -c 'git clone git@github.com:scoryst/scoryst.git /home/deploy/scoryst'

# add other necessary files/directories
sudo su - deploy -c 'mkdir /home/deploy/scoryst/logs'
sudo cp ~/files/scoryst/django/local_settings.py /home/deploy/scoryst/scorystproject/local_settings.py
sudo cp ~/files/scoryst/django/production-requirements.txt /home/deploy/scoryst/production-requirements.txt
sudo chown deploy:deploy /home/deploy -R

# set up virtualenv and install dependencies
sudo su - deploy -c 'virtualenv /home/deploy/scoryst/venv'
sudo su - deploy -c 'source /home/deploy/scoryst/venv/bin/activate && pip install -r /home/deploy/scoryst/requirements.txt'
sudo su - deploy -c 'source /home/deploy/scoryst/venv/bin/activate && pip install -r /home/deploy/scoryst/production-requirements.txt'

# link Django admin and debug toolbar static files
sudo su - deploy -c 'ln -s /home/deploy/scoryst/venv/lib/python2.7/site-packages/django/contrib/admin/static/admin /home/deploy/scoryst/scorystapp/static/admin'
sudo su - deploy -c 'ln -s /home/deploy/scoryst/venv/lib/python2.7/site-packages/debug_toolbar/static/debug_toolbar /home/deploy/scoryst/scorystapp/static/debug_toolbar'

# populate database from backup
sudo su - postgres -c 'source /home/deploy/scoryst/venv/bin/activate && python /home/deploy/scoryst/bin/restore_latest_backup'
