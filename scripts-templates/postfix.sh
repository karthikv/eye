# configure postfix to use TLS encryption
sudo cp ~/files/postfix/main.cf /etc/postfix/main.cf
sudo cp ~/files/postfix/smtpd.conf /etc/postfix/sasl/smtpd.conf
sudo cp ~/files/postfix/ssl/smtpd.key /etc/ssl/private/smtpd.key
sudo cp ~/files/postfix/ssl/cakey.pem /etc/ssl/private/cakey.pem
sudo cp ~/files/postfix/ssl/smtpd.crt /etc/ssl/certs/smtpd.crt
sudo cp ~/files/postfix/ssl/cacert.pem /etc/ssl/certs/cacert.pem

# use SASL for SMTP AUTH
sudo apt-get -y install libsasl2-2 sasl2-bin libsasl2-modules
sudo cp ~/files/postfix/saslauthd /etc/default/saslauthd
sudo dpkg-statoverride --force --update --add root sasl 755 /var/spool/postfix/var/run/saslauthd
sudo /etc/init.d/saslauthd start

# set up virtual aliases
sudo cp ~/files/postfix/virtual /etc/postfix/virtual
sudo postmap /etc/postfix/virtual
sudo service postfix restart
