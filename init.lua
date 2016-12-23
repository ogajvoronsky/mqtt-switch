WIFISSID   = "M"
WIFIPASS   = "Scherbata32"

function launch()
  print("Connected to WIFI!")
  print("IP Address: " .. wifi.sta.getip())
  -- Call our command file. Note: if you foul this up you'll brick the device!
  dofile("switch.lua")
end


function checkwificonn()
  ipAddr = wifi.sta.getip()
    if ( ( ipAddr ~= nil ) and  ( ipAddr ~= "0.0.0.0" ) )then
      tmr.alarm( 1 , 500 , tmr.ALARM_SINGLE , launch )
    else
      -- Wait more... 
      tmr.alarm( 0 , 1000 , tmr.ALARM_SINGLE , checkwificonn )
    end
end

print("-- Starting up! ")
 
-- Lets see if we are already connected by getting the IP
ipAddr = wifi.sta.getip()
if ( ( ipAddr == nil ) or  ( ipAddr == "0.0.0.0" ) ) then
  -- We aren't connected, so let's connect
  print("Configuring WIFI....")
  wifi.setmode( wifi.STATION )
  wifi.sta.config( WIFISSID , WIFIPASS)
  wifi.sta.autoconnect(1)
  print("Waiting for connection")
  tmr.alarm( 0 , 1000 , tmr.ALARM_SINGLE , checkwificonn )
else
 -- We are connected, so just run the launch code.
 launch()
end
