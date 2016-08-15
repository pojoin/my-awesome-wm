-- Widget and layout library
local wibox = require("wibox")
battery_widget = wibox.widget.textbox()
battery_widget:set_align("right")

function batteryInfo(adapter)
    spacer = " "
    local fremaining_percent = io.open("/sys/devices/platform/smapi/"..adapter.."/remaining_percent")
    local fsta = io.open("/sys/devices/platform/smapi/"..adapter.."/state")
    local remaining_percent = fremaining_percent:read()
    local sta = fsta:read()
    fremaining_percent:close()
    fsta:close()
    local battery = remaining_percent
    if sta == "charging" then
        dir = "⚡"
        battery = "A/C ("..battery.."%)"
    elseif sta == "discharging" then
        dir = "v"
        if tonumber(battery)<25 then
            if tonumber(battery)<10 then
                naughty.notify({title   = "Battery Warning"
                                ,text   = "Battery low!"..spacer..battery.."%"..spacer.."left!"
                                ,timeout    = 5
                                ,position   = "top_right"
                                ,fg         =beautiful.fg_focus
                                ,bg         = beautiful.bg_focus
                            })
            end
            battery = battery
        else
            battery = battery
        end
    else
        dir = "="
        battery = "A/C("..battery.."%)"
    end
    battery_widget:set_markup(spacer.."Bat:"..spacer..dir..battery..dir..spacer)
end

battery_timer = timer({timeout = 20})
battery_timer:connect_signal("timeout",function()
    batteryInfo("BAT0")
end)
battery_timer:start()
