local waypoints = textutils.unserialiseJSON(fs.open("TPData.json", "r").readAll() or "{}")
rednet.open("back")

--fs.open("TPData.json", "w").write(textutils.serialiseJSON({{Name = "Base", CID = 3}, {Name = "Tunnel", CID = 10}, {Name = "New jarland", Delay = 5, CID = 11}, {Name = "Blackhole Federation", Delay = 5, CID = 13}}))

function writeCenter(text, line)
    local x, y = term.getSize()
    term.setCursorPos(x/2 - string.len(text)/2, line)
    write(text)
end

function redraw()
    term.clear()
    writeCenter("Teleporters:", 1)
    local line = 2
    for ind, data in ipairs(waypoints) do
        writeCenter(data.Name, line)
        line = line + 1
    end
    
    writeCenter("Add new", line)
end

redraw()

function main()
    local selected = 0
    local prevSelected = 0
    local total = #waypoints + 1
    local text = (selected == #waypoints and "Add new") or waypoints[selected+1].Name
    local x, y = term.getSize()
    term.setCursorPos(x/2 - string.len(text)/2 - 1, selected+2)
    write(">")
    while true do
        if prevSelected ~= selected then
            local x, y = term.getSize()
            local text = (selected == #waypoints and "Add new") or waypoints[selected+1].Name
            term.setCursorPos(x/2 - string.len(text)/2 - 1, selected+2)
            write(">")
            local prevText = (prevSelected == #waypoints and "Add new") or waypoints[prevSelected+1].Name
            term.setCursorPos(x/2 - string.len(prevText)/2 - 1, prevSelected+2)
            write(" ")
        end
        
        local event, key = os.pullEvent()
        if event == "key" then
            if key == keys.w or key == keys.up then
                prevSelected = selected
                selected = (selected - 1 + total) % total
            elseif key == keys.s or key == keys.down then
                prevSelected = selected
                selected = (selected + 1) % total
            elseif key == keys.enter then
                if selected == #waypoints then
                    print(true)
                    -- add new waypoint
                else
                    term.clear()
                    if waypoints[selected + 1].Delay then
                        term.setCursorPos(1, 1)
                        write("Teleporting in " .. waypoints[selected + 1].Delay)
                        sleep(waypoints[selected + 1].Delay)
                    end
                    rednet.broadcast(waypoints[selected + 1].CID)
                    redraw()
                end
            end
        end
    end
end

parallel.waitForAny(function()
    while true do
        os.pullEvent("term_resize")
        redraw()
    end
end, main)
