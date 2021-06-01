#Turn on lights
gpio mode 27 out
gpio mode 28 out
gpio mode 29 out
gpio write 27 1
gpio write 28 1
gpio write 29 1

#Check i2c
sudo i2cdetect -y 1

#Check ADC
python ./convert_and_read_many.py

#Check Temp/Humidty Sensor
sudo bash -c "echo shtc1 0x70 > /sys/bus/i2c/devices/i2c-1/new_device"
sensors

#Display Check
sleep 2

# LoRa Card
cd /opt/ttn-gateway/bin/
./start.sh
