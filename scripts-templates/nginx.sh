# set up nginx configuration
sudo apt-get -y install nginx
sudo service nginx start

sudo cp ~/files/nginx/scoryst.com /etc/nginx/sites-available/scoryst.com
sudo ln -s /etc/nginx/sites-available/scoryst.com /etc/nginx/sites-enabled/scoryst.com
sudo rm /etc/nginx/sites-enabled/default

# add SSL certificates
sudo cp -r ~/files/nginx/ssl /home/deploy/ssl
