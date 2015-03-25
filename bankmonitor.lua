-- Version 0.50

-- Changelog:
-- Added TODO List
-- Mostly fixed indentation because OCD
-- Updated Pastebin with current code


-- ==================================

-- TODO
-- Add a way to have a second lamp track net gain/loss of power
-- Make Lamp(s) optional *still*
-- Refactor (Is this even the right word) term.write to use 
-- gpu.set instead, as well as setting it up so that only the
-- values that change every update will be redrawn, instead of 
-- the entire GUI
-- Make things prettier on the front end

-- Code Start


local component = require("component")
local os = require("os")
local term = require("term")

local gpu = component.gpu            -- Note that this program requires a T3 Screen.

local lamp = component.colorful_lamp -- As of right now, a Computronics Lamp is required. 
                                     -- I may take another stab at making it optional later on,
                                     -- but for now, it's required or the program will not run.

orange = 25984
yellow = 32736
red = 25600
green = 992
blue = 31

gpu.setResolution(32,1) -- For larger CapBank multiblocks, '32' may need to be increased to fit the amounts.

function checkBatt()
 curr = 0
 for addr, name in (component.list("capacitor_bank")) do
  battcheck = component.proxy(addr).getEnergyStored()
  curr = curr + battcheck
 end
 return curr
end

function getMaxBatt()
 max = 0
  for addr, name in (component.list("capacitor_bank")) do
   maxcheck = component.proxy(addr).getMaxEnergyStored()
   max = max + maxcheck
  end
 return max
end

function updateMon()
 term.clear()
 term.setCursor(1,1)
 io.stdout:write(curr .. "/" .. max .. " RF Stored.")
 return
end

function updateLamp()
 max = getMaxBatt()
 curr = checkBatt()
 perc = (curr / max) * 100
  if perc > 75 then do
   lamp.setLampColor(green)
  end
  elseif perc <= 75 and perc > 50 then do
   lamp.setLampColor(yellow)
  end
  elseif perc <=50 and perc > 25 then do
   lamp.setLampColor(orange)
  end
  elseif perc < 25 then do
   lamp.setLampColor(red)
  end
  elseif curr == 0 and max == 0 then do
   lamp.setLampColor(blue)
  end
 end
return
end


while true do

max = getMaxBatt()
curr = checkBatt()
updateMon()
updateLamp()
os.sleep(1)
end

-- Code End
