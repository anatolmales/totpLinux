#install google-authenticator
sudo apt-get install libpam-google-authenticator
sudo echo 'auth required pam_google_authenticator.so' > /etc/pam.d/sshd
#backup
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
#change sshd_config
sudo sed -i -e 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i -e 's/KbdInteractiveAuthentication no/KbdInteractiveAuthentication yes/g' /etc/ssh/sshd_config
sudo grep -q '^PermitRootLogin' /etc/ssh/sshd_config && sed -i 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config || sudo echo 'PermitRootLogin prohibit-password' >> /etc/ssh/sshd_config

google-authenticator -t -f -d -w 3 -e 10 -r 3 -R 30
sudo  systemctl restart sshd
