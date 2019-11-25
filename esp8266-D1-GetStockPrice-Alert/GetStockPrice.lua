-- tested on NodeMCU 0.9.5 build 20141222...20150108
-- sends connection time and heap size to http://hq.sinajs.cn/list=hk01308
IO_BLINK = 4
TMR_BLINK = 5
gpio.mode(IO_BLINK, gpio.OUTPUT)
blink = nil
tmr.register(TMR_BLINK, 100, tmr.ALARM_AUTO, function()
    gpio.write(IO_BLINK, blink.i % 2)
    tmr.interval(TMR_BLINK, blink[blink.i + 1])
    blink.i = (blink.i + 1) % #blink
end)
function blinking(param)
    if type(param) == 'table' then
        blink = param
        blink.i = 0
        tmr.interval(TMR_BLINK, 1)
        running, _ = tmr.state(TMR_BLINK)
        if running ~= true then
            tmr.start(TMR_BLINK)
        end
    else
        tmr.stop(TMR_BLINK)
        gpio.write(IO_BLINK, param or gpio.LOW)
    end
end

tmr.alarm(0, 60000, 1, function() --60√Î—≠ª∑“ª¥Œ
conn = nil
price = {}

conn=net.createConnection(net.TCP, 0) 
conn:on("receive", function(conn, payload) 
			success = true
		        for w in payload:gmatch("%d+%.%d+") do table.insert(price, w) end
			--ss=string.gsub(price[6])
			--ss=string.gsub(price[6],'%.','')
			--ss=string.gsub(ss,'.$','')
			--ss=string.format("%04d",ss)
			print(price[6])
			if tonumber(price[6]) > 9.00 then
			   blinking({100, 100 , 100, 500}) -- —≠ª∑…¡À∏£∫¡¡100ms£¨√100ms£¨¡¡100ms£¨√500ms
			else
			   blinking() -- ≥£¡¡
			end
end) 

conn:on("connection", function(conn, payload) 
                       conn:send("GET /list=hk01308"
                        .." HTTP/1.1\r\n" 
                        .."Host:hq.sinajs.cn\r\n" 
               		.."Connection: close\r\n"
                        .."Accept: */*\r\n" 
                        .."User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n" 
                        .."\r\n")
end) 

--conn:on("disconnection", function(conn, payload) 
--	print("Finished\r\n")
--	end)

                                     
conn:connect(80,'hq.sinajs.cn')

end)
