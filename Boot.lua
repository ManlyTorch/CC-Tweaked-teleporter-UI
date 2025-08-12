local waypoints = textutils.unserialiseJSON(fs.open("TPData.json", "r").readAll() or "{}")

function writeCenter(text, line)
    local x, y = term.getSize()
    term.setCursorPos(x/2 - string.len(text)/2, line)
    write(text)
end

function redraw()
    term.clear()
    writeCenter("Teleporters:", 1)
    local line = 2

    for ind, data in waypoints do
        writeCenter(data.Name, line)
        line = line + 1
    end

    writeCenter("Add new", line)
end

redraw()

function main()
    local selected = 0
    local total = #waypoints + 1
    while true do
        local event, key = os.pullEvent()
        if event == "key" then
            if key == keys.w or key == keys.up then
                selected = (selected - 1 + total) % total
            elseif key == keys.s or key == keys.down then
                selected = (selected + 1) % total
            elseif key == keys.enter then
                if selected == #waypoints then
                    print(true)
                    -- add new waypoint
                else
                    --
                end
            end
        end
    end
end

parallel.waitForAny(function()
    os.pullEvent("term_resize")
    redraw()
end, main)
