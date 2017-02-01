# mqtt-switch
Simple implementation of MQTT-switch on nodeMCU (ESP8266) LUA

It subscribe to specified topic, recieve command and update GPIO pin 0 accordingly.
Publish own status to status topic on change and every 10sec 
If MQTT-broker goes offline (status publishing failed) - restart and reconnect.

