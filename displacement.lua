--[[

A simple pixel displacement script for Asesprite.

Shifts all pixels that succeed the probability test by at most the maximum amount of displacement specified

Author: Heidi Uri
Date: 2019-06-29
--]]

local dialog = Dialog("Displacement")
dialog:number { id="probability", label="Probability of Displacement", text="0.5", decimals=2}
dialog:number { id="xDistance", label="Max X-Displacement", text="1", decimals=0}
dialog:number { id="yDistance", label="Max Y-Displacement", text="1", decimals=0}
dialog:button { id="info", text="&Info", onclick = info}
dialog:button { id="run", text="&Run", focus=true, onclick = displace }
dialog:button { text="&Close" }

function info ()
    print("A pixel displacement script that shifts all pixels succeeding probability test at most by the maximum amount of displacement specified.")
    print(" ")
    print("Probability is between 0-1. If set to 1, it always executes displacement.")
    print("The x-distance and y-distance are maximum distance of displacement in given axis 'if' the probability check succeeds")
    print(" ")
    print("Author: Heidi Uri")
    print("Date: 2019-06-29")
end

function displace()
    local sprite = app.activeSprite
    
    for i,cel in ipairs(sprite.cels) do
        local image = Image(cel.image.width, cel.image.height, cel.image.colorMode)
                
        for x = 0, cel.image.width do
            for y = 0, cel.image.height do
                local pixel = cel.image:getPixel(x, y)
                
                if math.random(0, 1) < dialog.data.probability then
                    local dx = math.random(-dialog.data.xDistance, dialog.data.yDistance)
                    local dy = math.random(-dialog.data.xDistance, dialog.data.yDistance)
                    local x2 = x + dx
                    local y2 = y + dy
                    
                    if x2 >= 0 and x2 < cel.image.width and y2 >= 0 and y2 < cel.image.height then
                        pixel = cel.image:getPixel(x + dx, y + dy)
                    end
                    
                    image:drawPixel(x, y, pixel)
                else
                    image:drawPixel(x, y, pixel)
                end                
            end
        end        
        
        cel.image = image
    end
    
    app.refresh()
end

dialog:show{wait=false}
