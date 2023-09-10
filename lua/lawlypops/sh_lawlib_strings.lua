if CLIENT then
    surface.CreateFont("Lawlib:Monospace", {
        font = "Consolas",
        size = 20
    })
end

function LAWLIB:SpaceBuffer(txt, len)
    local Ftxt = txt
    for i=#txt, len, 1 do
        Ftxt = Ftxt .. " "
    end
    return Ftxt
end