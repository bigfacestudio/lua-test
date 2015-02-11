--[[


-- use it


mf=require("myfile")


mf.print("init.lua")


--]]





gpio= {[0]=3, [1]=10, [2]=4, [3]=0, [4]=2, [5]=1, [10]=12, [12]=6, [13]=7, [14]=5, [15]=8,[16]=0}
--sda=gpio[12] -- connect sda to pin GPIO12
--led=gpio[14] -- connect led to pin GPIO14

local myfile = {}
function myfile.print(name)
  file.open(name)
  repeat
    local line=file.readline()
    if line
    then line=(string.gsub(line,"\n",""))
      print(line)
    end
  until not line
  file.close()
end
return myfile






