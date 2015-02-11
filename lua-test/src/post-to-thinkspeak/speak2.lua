pin = 9
ow.setup(pin)
count = 0
repeat
  count = count + 1
  addr = ow.reset_search(pin)
  addr = ow.search(pin)
  tmr.wdclr()
until((addr ~= nil) or (count > 100))
if (addr == nil) then
  print("No more addresses.")
else
  print(addr:byte(1,8))
  crc = ow.crc8(string.sub(addr,1,7))
  if (crc == addr:byte(8)) then
    if ((addr:byte(1) == 0x10) or (addr:byte(1) == 0x28)) then
      print("Device is a DS18S20 family device.")
      --repeat
      ow.reset(pin)
      ow.select(pin, addr)
      ow.write(pin, 0x44, 1)
      tmr.delay(1000000)
      present = ow.reset(pin)
      ow.select(pin, addr)
      ow.write(pin,0xBE,1)
      print("P="..present)
      data = nil
      data = string.char(ow.read(pin))
      for i = 1, 8 do
        data = data .. string.char(ow.read(pin))
      end
      print(data:byte(1,9))
      crc = ow.crc8(string.sub(data,1,8))
      print("CRC="..crc)
      if (crc == data:byte(9)) then
        t = (data:byte(1) + data:byte(2) * 256) * 625
        t1 = t / 1000
        t2 = t % 1000
        print("Temperature= "..t1.."."..t2.." Centigrade")

      end
      tmr.wdclr()
      --until false
    else
      print("Device family is not recognized.")
    end
  else
    print("CRC is not valid!")
  end
end



conn=net.createConnection(net.TCP, 0)
conn:on("receive", function(conn, payload) print(payload) end)
conn:connect(80,'184.106.153.149')
conn:send("GET /update?key=Yourey&field1="..t1.."."..t2.." HTTP/1.1\r\n")
conn:send("Host: api.thingspeak.com\r\n")
conn:send("Accept: */*\r\n")
conn:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n")
conn:send("\r\n")
