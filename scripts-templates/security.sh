# set up package manager and upgrade packages
sudo apt-get update
sudo apt-get -y upgrade

# create user for deployment
sudo useradd deploy
sudo mkdir /home/deploy
sudo mkdir /home/deploy/.ssh
sudo chmod 700 /home/deploy/.ssh

# add SSH keys
sudo cp ~/files/security/authorized_keys /home/deploy/.ssh/authorized_keys
sudo chmod 400 /home/deploy/.ssh/authorized_keys
sudo chown deploy:deploy /home/deploy -R
sudo chsh -s /bin/bash deploy

# allow sudo access
sudo adduser deploy sudo
<% if (production) { %>
  cat ~/files/security/deploy-password | sudo chpasswd
<% } else { %>
  echo "deploy:deploy" | sudo chpasswd
<% } %>

# secure SSH
sudo cp ~/files/security/sshd_config /etc/ssh/sshd_config
sudo service ssh restart

<% if (production) { %>
  # add common security packages
  sudo apt-get -y install fail2ban
  sudo apt-get -y install unattended-upgrades
  sudo cp ~/files/security/10periodic /etc/apt/apt.conf.d/10periodic

  sudo debconf-set-selections <<< "postfix postfix/mailname string scoryst.com"
  sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
  sudo apt-get -y install logwatch
  sudo cp ~/files/security/00logwatch /etc/cron.daily/00logwatch
<% } %>
