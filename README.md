# mqtt-switch
Simple my own implementation of MQTT-switch on nodeMCU (ESP8266) LUA

It subscribe to specified topic, recieve command and update GPIO pin 0 accordingly.
Publish own status to status topic on change and every 10sec for keep connection alive. 
If MQTT-broker goes offline (publish failed) - restart node and reconnect to broker.



