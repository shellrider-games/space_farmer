import "listUtil"

tickBarImg = file.loadImage("images/tickbar.png")

img = tickBarImg
currentValue = 0
maxValue = 1
speed = 1

subscribed = []

update = function(elapsed)
    outer.currentValue = (currentValue + elapsed * speed)
    if currentValue >= maxValue then 
        invoke
        outer.currentValue = currentValue % maxValue
    end if
end function

subscribe = function(fn)
    if subscribed.contains(@fn) then return
    subscribed.push @fn
end function

invoke = function
    for fn in subscribed
        fn
    end for
end function