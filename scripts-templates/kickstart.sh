# restart supervisor and nginx
sudo service supervisor restart
sudo supervisorctl reread
sudo supervisorctl update
sudo service nginx restart
