util.AddNetworkString("lawlib_notify")

function LAWLIB:Notify(ply, txt, style, len)
    if !IsValid(ply) then return end
    if #txt <= 0 then return end
    if style == nil then style = 0 end
    if len == nil then len = 5 end

    style = math.Clamp(style, 0, 15)
    len = math.Clamp(len, 0, 255)

    net.Start("lawlib_notify")
        net.WriteString(txt)
        net.WriteUInt(style, 4)
        net.WriteUInt(len, 8)
    net.Send(ply)
end