LAWLIB.ShopData = {}

function LAWLIB:PurchaseItem(itemID, pos)
    net.Start("lawlib_economy")
        net.WriteUInt(0, 8) -- Purchase Item
        net.WriteString(itemID)
        net.WriteVector(pos)
    net.SendToServer()
end

net.Receive("lawlib_economy", function()
    local cmd = net.ReadUInt(8)
    if cmd == 0 then -- Update Shop Data
        local newTable = net.ReadBool()
        if newTable then
            table.Empty(LAWLIB.ShopData)
            local tblLen = net.ReadUInt(8)
            local tbl = {}
            for i=1, tblLen, 1 do
                local itemID = net.ReadString()
                local niceName = net.ReadString()
                local cost = net.ReadFloat()
                LAWLIB.ShopData[itemID] = {Name=niceName, Cost=cost}
            end
        else
            LAWLIB.ShopData[net.ReadString()] = {Name=net.ReadString(), Cost=net.ReadFloat()}
        end
    end
end)