MQTT_Broker = "220ua.com"
MQTT_port   = 1883
MQTT_user   = "hryniv"
MQTT_pass   = "LJ8uQSqYlR6i"
topic       = "/hr/command/towers_light"
status	    = "/hr/status/towers_light"
pin         = 0
last_msg    = ""

function mqtt_connect()
    broker = mqtt.Client("towers_esp", 30, MQTT_user, MQTT_pass)
    broker:lwt("/lwt", "offline", 0, 0)
    tmr.alarm(2, 10000, tmr.ALARM_AUTO, mqtt_check_connection )
    if broker:connect(MQTT_Broker, MQTT_port, 0, 1, function(con) 
      mqtt_sub()
      end) then print("MQTT connectting to:", MQTT_Broker)
      else node.restart()
    end
end

function mqtt_msg_recieved(client, topic, msg)
  f=file.open("state","w+")
  if msg == "ON" then  
        gpio.write(pin, gpio.HIGH) 
        f.write(msg)
	broker:publish(status, "ON" ,0,0)	
  end
      
  if msg == "OFF" then 
        gpio.write(pin, gpio.LOW) 
        f.write(msg)
	broker:publish(status, "OFF" ,0,0)
  end
  last_msg=msg
  f.close()
    
  print("debug:",client,topic,msg)
end

function mqtt_check_connection()
    if not broker:publish(status, last_msg ,0,0) 
       then node.restart()
    end
end


function mqtt_subscribed()
  broker:on("message", function(client, topic, msg)
        mqtt_msg_recieved(client, topic, msg)
  end)
  
  if not (last_msg == "ON" or last_msg == "OFF") then 
    last_msg="OFF"
    f=file.open("state","w+")
    f.write(last_msg)
    f.close()
  end
  
  mqtt_check_connection()
  print("MQTT Subscribed to:", topic)
    
end

function mqtt_sub()
  -- read & set callback for changes
  broker:subscribe(topic, 0, function(client) 
        mqtt_subscribed()
  end)
 
end


gpio.mode(pin, gpio.OUTPUT)
f=file.open("state")
if not (f == nil) then
    last_msg=f.read()
    f.close()
  else
    last_msg="OFF"
    f=file.open("state","w+")
    f.write(last_msg)
    f.close()
end

mqtt_connect()
