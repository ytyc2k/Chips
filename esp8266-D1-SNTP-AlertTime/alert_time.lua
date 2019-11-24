chg2min=function(hm)
  local c1,c2 = string.match(hm,"(%d+):(%d+)")
  c1=c1+0
  c2=c2+0
  if c1 >= 24 then
    c1=c1%24
  end
  return c1*60+c2
end

beep=function()
  gpio.mode(2,gpio.OUTPUT)
  gpio.mode(5,gpio.OUTPUT)
  for _,i in ipairs({1,0,1,0,1,0,1,0,1,0,1,0,1,0}) do
    gpio.write(2,i)
    gpio.write(5,i)
    tmr.delay(250000)
  end
end

function GetTime()
    print("Start getTime")
    sntp.sync('ca.pool.ntp.org',
    function(sec,usec,server)
      if sec ~= nil then

	local tmlst2={999}
        local mcha
	local tm = rtctime.epoch2cal(sec-60*60*5)
        local T1 = string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"],tm["hour"],tm["min"],tm["sec"])
        local SS=tm["sec"]+0

        print("Current Time is :"..T1)

	for _,k in ipairs(tmlst1) do
	  mcha=chg2min(k)-chg2min(T1)
	  if  mcha >= 0 then
	    table.insert(tmlst2,mcha)
	  end
	end

        table.sort(tmlst2)

	if(tmlst2[1] == 0) then
	  print("System is now doing action and will restart "..60-SS.." seconds later!")
          tmr.delay(1000000)
          beep()
	  rtctime.dsleep((60-SS)*1000000,4)  
	elseif(tmlst2[1] < 60) then
	  print("System will restart "..(tmlst2[1]-1).." mintues "..60-SS.." seconds later!")
          tmr.delay(1000000)
	  rtctime.dsleep((tmlst2[1]*60-SS+10)*1000000,4)
	else
	  print("System will restart 1 hour later!")
          tmr.delay(1000000)
	  rtctime.dsleep(60*60*1000000,4)      
	end

      end
    end,
    function()
      print('failed!')
    end
  )
end

tmlst1={"7:00","07:15","07:30","07:45","08:00","08:10","08:20","08:30","08:35","08:40","12:00","19:45","19:50","19:55","20:00","20:30","22:00"}
GetTime()
