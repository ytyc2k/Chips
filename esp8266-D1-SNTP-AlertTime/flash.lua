for _,i in ipairs({1,0,1,0,1,0,1,0,1,0,1,0,1,0}) do
      gpio.write(5,i)
      gpio.write(2,i)
      tmr.delay(250000)
end