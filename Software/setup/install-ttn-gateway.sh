sudo apt install i2c-tools gpsd

rsync -r ttn-gateway/ /opt -v
cp lora_pkt_fwd.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable lora_pkt_fwd
systemctl start lora_pkt_fwd
