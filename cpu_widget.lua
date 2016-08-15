-- Widget and layout library
local wibox = require("wibox")
cpu_widget = wibox.widget.textbox()
cpu_widget:set_align("right")

jiffies = {}
function activecpu()
    local s = ""
    for line in io.lines("/proc/stat") do
        local cpu,newjiffies = string.match(line, "(cpu%d*) +(%d+)")
        if cpu and newjiffies then
            if not jiffies[cpu] then
                jiffies[cpu] = newjiffies
            end
            s = s.." "..cpu..": "..string.format("%02d", newjiffies-jiffies[cpu]).."% "
            jiffies[cpu] = newjiffies
        end
    end
    cpu_widget:set_markup(s)
end

cpu_timer = timer({timeout = 5})
cpu_timer:connect_signal("timeout",function()
    activecpu()
end)
cpu_timer:start()
