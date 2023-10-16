
function LAWLIB:SpaceBuffer(txt, len)
    local Ftxt = txt
    for i=#txt, len, 1 do
        Ftxt = Ftxt .. " "
    end
    return Ftxt
end