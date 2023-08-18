util.AddNetworkString("lawlib_openmenu")

function LAWLIB:OpenMenu(menuName, ply, ent, tbl, cmd)
    if cmd == nil then cmd = "" end
    net.Start("lawlib_openmenu")
        net.WriteString(menuName)
        net.WriteEntity(ent)
        net.WriteString(cmd)
        if tbl != nil then
            net.WriteTable(tbl)
        end
    net.Send(ply)
end

//Request to opem entity menu from client.
net.Receive("lawlib_openmenu", function(len, ply)
    local ent = net.ReadEntity()
    local cmd = net.ReadString()
    if !IsValid(ent) then return end
    if ent.OpenMenu then ent:OpenMenu(ply, cmd) end
end)