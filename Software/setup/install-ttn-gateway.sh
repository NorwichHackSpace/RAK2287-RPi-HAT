
#GPIO
apt -y install libgpiod-dev gpiod

#Network (if Gateway to be setup remotely with mobile data)
#apt install autossh
#ssh-keygen -f ~/.ssh/experimental-lora -t ed25519 -N ""
#ssh-copy-id -i ~/.ssh/experimental-lora rssh@home.megazirt.co.uk
#Test -> sudo /usr/bin/autossh -M 0 -o "ServerAliveInterval 120" -o "ServerAliveCountMax 6" -NR 22001:localhost:22 rssh@home.megazirt.co.uk -i /home/pi/.ssh/experimental-lora -v
#Test -> ssh -R 22001:localhost:22 rssh@home.megazirt.co.uk -i ~/.ssh/experimental-lora -N
#Edit service file here
#cp autossh-tunnel.service /etc/systemd/system/
#systemctl daemon-reload
#systemctl start autossh-tunnel.service
#systemctl enable autossh-tunnel.service

#GPS (and time)
apt -y install i2c-tools gpsd pps-tools ntp
apt -y remove fake-hwclock
systemctl stop gpsd.service
systemctl stop gpsd.socket
bash -c "grep -qxF 'pps-gpio' /etc/modules || echo 'pps-gpio' >> /etc/modules"
bash -c "mkdir /etc/systemd/system/gpsd.socket.d/"
bash -c "cp gpsd.socket.conf /etc/systemd/system/gpsd.socket.d/socket.conf"
bash -c "cp ntpd /usr/sbin/ntpd"
bash -c "cp ntp.conf /etc/ntp.conf"
systemctl daemon-reload
systemctl disable systemd-timesyncd.service
systemctl stop systemd-timesyncd.service
systemctl stop ntp.service
systemctl start ntp.service
systemctl enable ntp.service


#Core LoRa
rsync -r ttn-gateway/ /opt -v
cp lora_pkt_fwd.service /etc/systemd/system/
systemctl daemon-reload
systemctl start lora_pkt_fwd
systemctl enable lora_pkt_fwd
#Chirstack multiplexer -> https://github.com/brocaar/chirpstack-packet-multiplexer
rsync -r chirpstack-multiplexer/* /opt/ttn-gateway/bin/ -v
cp lora_pkt_fwd.service /etc/systemd/system/
lora-multiplexer.service

