#!/bin/bash

# Установка google-authenticator
sudo apt install libpam-google-authenticator -y

# Добавление строки в файл PAM
echo 'auth required pam_google_authenticator.so' | sudo tee -a /etc/pam.d/sshd > /dev/null

# Резервное копирование конфигурации SSH
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Изменение sshd_config
sudo sed -i -e 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i -e 's/KbdInteractiveAuthentication no/KbdInteractiveAuthentication yes/g' /etc/ssh/sshd_config

# Замена PermitRootLogin
if sudo grep -q '^PermitRootLogin' /etc/ssh/sshd_config; then
    sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
else
    echo 'PermitRootLogin prohibit-password' | sudo tee -a /etc/ssh/sshd_config > /dev/null
fi

# Запуск google-authenticator
cd ~
google-authenticator -t -f -d -w 15 -r 3 -R 60 -C -e 5

# Отображение секретного ключа
cat ./.google_authenticator

# Перезапуск службы SSH
sudo systemctl restart sshd
