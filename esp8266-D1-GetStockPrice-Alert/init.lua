wifi.setmode(wifi.STATION)
wifi.sta.config("BELL142","1644F25A")
wifi.sta.connect()

local cnt = 1
tmr.alarm(1, 1000, 1, function()
    if (wifi.sta.getip() == nil) and (cnt <= 20) then
        cnt = cnt + 1
    else
        if (cnt <= 20) then
            tmr.stop(1)
            dofile("GetStockPrice.lua")
        else
            cnt = 1
            wifi.sta.connect()
        end
    end
end)

