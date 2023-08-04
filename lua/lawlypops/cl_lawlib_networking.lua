if !LAWLIB.Networking then LAWLIB.Networking = {} end
if !LAWLIB.Networking.Menus then LAWLIB.Networking.Menus = {} end

function LAWLIB:RegisterMenu(menuName, menuTable)
    LAWLIB.Networking.Menus[menuName] = menuTable
end

function LAWLIB:OpenEntMenu(ent, cmd)
    if !IsValid(ent) then return end
    net.Start("lawlib_openmenu")
        net.WriteEntity(ent)
        net.WriteString(cmd)
    net.SendToServer()
end

net.Receive("lawlib_openmenu", function()
    local _Type = net.ReadString()
    if LAWLIB.Networking.Menus[_Type] then
        //MsgN("[LAWLIB] Recieved request to open \"" .. _Type .. "\"")
        local menu = LAWLIB.Networking.Menus[_Type]
        local ent = net.ReadEntity()
        local cmd = net.ReadString()
        local tbl = {}
        if menu.RequiresTable then
            tbl = net.ReadTable()
        end
        menu:CreateMenu(ent, tbl, cmd)
    else
        MsgN("[LAWLIB] Cannot open menu of type \"" .. _Type .. "\" (menu is nil)")
    end
end)