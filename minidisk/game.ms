import "tickbar"

clear

UI_LAYER = 2

textDisplay = display(3)
textDisplay.delimiter = ""

createUIDisplays = function()
    displays = []
    ui1 = new PixelDisplay
    ui2 = new PixelDisplay
    displays.push ui1
    displays.push ui2
    return displays
end function

drawTickBar = function(ui,tickBar)
    ui.drawImage tickBar.img, 172, 148, 60*tickBar.currentValue, 6, 0, 0, 60*tickBar.currentValue, 6
end function

drawWaterAmount = function(ui, amount)
    ui.column = 0
    ui.row = 25
    ui.backColor = color.clear
    ui.color = "#5ee9e9"
    ui.print "Water: " + amount
end function

drawWaterCollectorAmount = function(ui, amount)
    ui.column = 0
    ui.row = 24
    ui.backColor = color.clear
    ui.color = "#005f41"
    ui.print "Water collectors: " + amount
end function

drawTextMenu = function(ui)
    ui.color = color.black
    ui.backColor = color.white
    for col in range(0,67,1)
        ui.setCellBackColor col, 0, color.white
    end for
    ui.column = 0; ui.row = 0;
    ui.print "(B)uy water collector, costs " + waterCollectorCost + " water"
end function

nextUIFrame = function(displays)
    textDisplay.backColor = color.clear
    textDisplay.clear
    displays.currentId = (displays.currentId + 1) % displays.displays.len
    displays.displays[displays.currentId].install UI_LAYER
    displays.displays[displays.currentId].clear
    displays.displays[displays.currentId].scale = 4
end function

uiDisplays = {}
uiDisplays.displays = createUIDisplays
uiDisplays.currentId = 0
uiDisplays.current = function
    return self.displays[self.currentId]
end function

waterAmount = 0
waterCollectorAmount = 1

waterCollectorCost = function
    return floor(10 * 1.2^(waterCollectorAmount-1))
end function

increaseWater = function
    outer.waterAmount = waterAmount + waterCollectorAmount
end function

decreaseWater = function
    if waterAmount >= waterCollectorCost then 
        outer.waterAmount = waterAmount - waterCollectorCost
        outer.waterCollectorAmount = waterCollectorAmount + 1
    end if
end function

nextUIFrame uiDisplays

tickbar.subscribe @increaseWater

justPressedB = false

lastTimestamp = time
while not key.pressed("q")
    if key.pressed("b") then
        if not justPressedB then decreaseWater
        justPressedB = true
    else
        justPressedB = false
    end if

    nextUIFrame uiDisplays
    currentTimestamp = time
    delta = currentTimestamp - lastTimestamp
    lastTimestamp = currentTimestamp
    tickbar.update delta
    drawTickBar uiDisplays.current, tickbar
    drawTextMenu textDisplay
    drawWaterAmount textDisplay, waterAmount
    drawWaterCollectorAmount textDisplay, waterCollectorAmount
    yield
end while

textDisplay.color = color.orange
key.clear
clear