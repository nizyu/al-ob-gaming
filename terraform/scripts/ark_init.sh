#!/bin/bash

# @sacloud-once
# @sacloud-desc-begin
#   ARKのインストールスクリプト
#   以下を参考に作成
#   https://ark.fandom.com/wiki/Dedicated_server_setup
# @sacloud-desc-end
#
# @sacloud-password ark_server_password "ARKサーバーパスワード"

## base
sed -i "/^[^#]*PasswordAuthentication[[:space:]]yes/c\PasswordAuthentication no" /etc/ssh/sshd_config
systemctl restart sshd

## prepare install
adduser --system steam

## install SteamCMD
add-apt-repository multiverse
apt-get -y install software-properties-common
dpkg --add-architecture i386
apt-get update
apt-get -y upgrade
apt-get -y install lib32gcc-s1

echo steam steam/question select "I AGREE" | sudo debconf-set-selections
echo steam steam/license note '' | sudo debconf-set-selections
apt-get -y install steamcmd

## install ARK
sudo -u steam mkdir -p /home/steam/servers/ark
sudo -u steam /usr/games/steamcmd +force_install_dir /home/steam/servers/ark +login anonymous +app_update 376030 +quit

## auto start ARK
cat << EOF > /etc/systemd/system/ark-dedicated.service 
[Unit]
Description=ARK: Survival Evolved dedicated server
Wants=network-online.target
After=syslog.target network.target nss-lookup.target network-online.target

[Service]
ExecStartPre=/usr/games/steamcmd +login anonymous +force_install_dir /home/steam/servers/ark +app_update 376030 +quit
ExecStart=/home/steam/servers/ark/ShooterGame/Binaries/Linux/ShooterGameServer TheIsland?listen?SessionName=accenture?ServerPassword=@@@ark_server_password@@@?ServerAdminPassword=admin_@@@ark_server_password@@@ -server -log
WorkingDirectory=/home/steam/servers/ark/ShooterGame/Binaries/Linux
LimitNOFILE=100000
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s INT $MAINPID
User=steam
Group=nogroup

[Install]
WantedBy=multi-user.target
EOF

systemctl enable ark-dedicated
