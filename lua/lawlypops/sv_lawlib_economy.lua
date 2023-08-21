util.AddNetworkString("lawlib_economy")

LAWLIB.ShopItems = {}

function LAWLIB:AddShopItem(itemID, niceName, cost, itemType, class)

    local errorName = "none"
    if itemID == nil then errorName = "1 [itemID]" elseif
    niceName == nil then errorName = "2 [niceName]" elseif
    cost == nil then errorName = "3 [cost]" elseif
    itemType == nil then errorName = "4 [itemType]" elseif
    class == nil then errorName = "5 [class]" end

    if errorName != "none" then
        ErrorNoHaltWithStack("[LAWLIB] Could not add shop item! Argument " .. errorName .. " is nil!")
        return nil
    end

    LAWLIB.ShopItems[itemID] = {Name=niceName, Cost=cost, Type=itemType, Class=class}

    LAWLIB:SendShopData(itemID)
end

function LAWLIB:SendShopData(specificID)
    local all = false
    if specificID == nil then all = true end
    
    net.Start("lawlib_economy")
        net.WriteUInt(0, 8) -- Update Shop Data

        net.WriteBool(all)
        if all then
            local tblLen = table.Count(LAWLIB.ShopItems)
            net.WriteUInt(tblLen, 8)
            for itemID, tbl in pairs(LAWLIB.ShopItems) do
                net.WriteString(itemID)
                net.WriteString(tbl.Name)
                net.WriteFloat(tbl.Cost)
            end
        else
            local tbl = LAWLIB.ShopItems[specificID]
            net.WriteString(specificID)
            net.WriteString(tbl.Name)
            net.WriteFloat(tbl.Cost)
        end
    net.Broadcast()
end

function LAWLIB:GetShopItem(itemName)

end

function LAWLIB:GetShopItemNames()

end

net.Receive("lawlib_economy", function(len, ply)
    local cmd = net.ReadUInt(8)

    if cmd == 0 then -- Purchase Item
        local itemID = net.ReadString()
        local tbl = LAWLIB.ShopItems[itemID]
        MsgN(table.Count(LAWLIB.ShopItems))
        if !istable(tbl) then return end
        if DarkRP then
            local money = ply:getDarkRPVar("money")
            if money < tbl.Cost then
                LAWLIB:Notify(ply, "You cannot afford that!", 1, 4)
                return
            end
            ply:addMoney(-tbl.Cost)
            LAWLIB:Notify(ply, "Purchased " .. tbl.Name .. " for " .. DarkRP.formatMoney(tbl.Cost), 0, 4)
        else
            LAWLIB:Notify(ply, "Purchased " .. tbl.Name .. " for " .. tbl.Cost, 0, 4)
        end
        if tbl.Type == "weapon" then
            ply:Give(tbl.Class)
        elseif tbl.Type == "entity" then
            local newEnt = ents.Create(tbl.Class)
            local tr = ply:GetEyeTrace()
            newEnt:SetPos(tr.HitPos + tr.HitNormal * 5)
            newEnt:Spawn()
        end
    end
end)
