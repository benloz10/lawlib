util.AddNetworkString("lawlib_economy")

LAWLIB.ShopItems = {}

function LAWLIB:AddShopItem(itemID, niceName, cost, itemType, class, limit)

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

   
    
    if limit != nil then LAWLIB.Config.MaxEnts[class] = limit end


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
        local pos = net.ReadVector()
        local tbl = LAWLIB.ShopItems[itemID]
        if !istable(tbl) then return end
        if tbl.Type == "weapon" then
            local wep = ply:Give(tbl.Class)
            if wep == NULL then
                LAWLIB:Notify(ply, "You already have one!", 0, 5)
                return
            end
        elseif tbl.Type == "entity" then
            local entCount = 0
            for _, countEnt in ipairs(ents.FindByClass(tbl.Class)) do
                if !countEnt.Owner or countEnt.Owner != ply then continue end
                entCount = entCount + 1
            end
            if entCount >= LAWLIB.Config.MaxEnts[tbl.Class] or LAWLIB.Config.MaxEnts.default then
                LAWLIB:Notify(ply, "Reached max limit!", 0, 5)
                return
            end
            local newEnt = ents.Create(tbl.Class)
            local tr = ply:GetEyeTrace()
            if pos == nil then pos = tr.HitPos + tr.HitNormal * 5 end
            newEnt:SetPos(pos)
            newEnt:Spawn()
            newEnt:DropToFloor()
            newEnt:PhysWake()
            newEnt:SetNWEntity("Owner", ply)
        end
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
    end
end)
