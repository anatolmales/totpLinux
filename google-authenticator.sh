function pause(){
 read -s -n 1 -p "Press any key to continue . . ."
 echo ""
}
#install google-authenticator
sudo apt install libpam-google-authenticator -y
pause
sudo echo 'auth required pam_google_authenticator.so' >> /etc/pam.d/sshd
#backup
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
#change sshd_config
pause
sudo sed -i -e 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
pause
sudo sed -i -e 's/KbdInteractiveAuthentication no/KbdInteractiveAuthentication yes/g' /etc/ssh/sshd_config
pause
sudo grep -q '^PermitRootLogin' /etc/ssh/sshd_config && sed -i 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config || sudo echo 'PermitRootLogin prohibit-password' >> /etc/ssh/sshd_config
pause
cd ~
google-authenticator -t -f -d -w 15 -r 3 -R 60 -C -e 5
cat ./.google_authenticator
sudo  systemctl restart sshd
