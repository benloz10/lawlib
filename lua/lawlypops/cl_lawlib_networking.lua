if !LAWLIB.MENUS then LAWLIB.MENUS = {} end

function LAWLIB:RegisterMenu(menuName, menuTable)
    LAWLIB.MENUS[menuName] = menuTable
end

net.Receive("lawlib_openmenu", function()
    local _Type = net.ReadString()
    if LAWLIB.MENUS[_Type] then
        //MsgN("[LAWLIB] Recieved request to open \"" .. _Type .. "\"")
        local menu = LAWLIB.MENUS[_Type]
        local ent = net.ReadEntity()
        local tbl = {}
        if menu.RequiresTable then
            tbl = net.ReadTable()
        end
        menu:CreateMenu(ent, tbl)
    else
        MsgN("[LAWLIB] Cannot open menu of type \"" .. _Type .. "\"")
    end
end)