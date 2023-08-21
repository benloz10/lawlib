if !LAWLIB.Menus then LAWLIB.Menus = {} end

function LAWLIB:RegisterMenu(menuName, menuTable)
    LAWLIB.Menus[menuName] = menuTable
end

function LAWLIB:OpenMenu(_Type, cmd)
    local menu = LAWLIB.Menus[_Type]
    if menu == nil then return end
    menu:CreateMenu(cmd)
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
    if LAWLIB.Menus[_Type] then
        //MsgN("[LAWLIB] Recieved request to open \"" .. _Type .. "\"")
        local menu = LAWLIB.Menus[_Type]
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