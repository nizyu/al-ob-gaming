#!/bin/bash

# @sacloud-once
# @sacloud-desc-begin
#   7 days to dieのインストールスクリプト
# @sacloud-desc-end
#
# @sacloud-password 7dtd_server_password "7dtdサーバーパスワード"

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

## install 7dtd
sudo -u steam mkdir -p /home/steam/servers/7dtd
sudo -u steam /usr/games/steamcmd +force_install_dir /home/steam/servers/7dtd +login anonymous +app_update 294420 +quit

## change password
sed -i '/ServerPassword/c <property name="ServerPassword" value="@@@7dtd_server_password@@@"\/>/'  /home/steam/servers/7dtd/serverconfig.xml 

## auto start 7dtd
cat << EOF > /etc/systemd/system/7dtd-dedicated.service
[Unit]
Description=seven days to die dedicated server
Wants=network-online.target
After=syslog.target network.target nss-lookup.target network-online.target

[Service]
ExecStartPre=/usr/games/steamcmd +login anonymous +force_install_dir /home/steam/servers/7dtd +app_update 294420 +quit
ExecStart=/home/steam/servers/7dtd/startserver.sh
ExecStop=-/bin/bash -c "echo 'shutdown' | /usr/bin/telnet 127.0.0.1 8081"
WorkingDirectory=/home/steam/servers/7dtd/
LimitNOFILE=100000
User=steam
Group=nogroup

[Install]
WantedBy=multi-user.target
EOF

systemctl enable 7dtd-dedicated
