function write(text, line)
    local x, y = term.getSize()
    term.setCursorPos(string.len(text)/2 + x, line)
    write(text)
end

function redraw()
    term.clear()
    write("Teleports:", 1)
    write("ABCDEFGHIJKLMNOP", 2)
end

redraw()
