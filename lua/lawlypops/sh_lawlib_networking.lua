if !LAWLIB.Networking then LAWLIB.Networking = {} end

function LAWLIB.ReadTable()
    
    for i, data in ipairs(LAWLIB.Networking.LastTableData) do
        local _Type = type(data)
    end
end

function LAWLIB.WriteTable(tbl)
    net.WriteBool(table.IsSequential(tbl))
    local dataTable = {}
    table.Empty(dataTable)
    --Prep data table for sending. Separates by type.
    for i, data in pairs(tbl) do
        local _Type = typeID(data)
        if !dataTable[_Type] then dataTable[_Type] = {} end
        table.insert(dataTable[_Type], data)
    end
    --Send the count of each table amount
    for i, data in pairs(dataTable) do
        if i == TYPE_ANGLE then
            
            continue
        end
        if i == TYPE_BOOL then
            
            continue
        end
        if i == TYPE_COLOR then
            
            continue
        end
        if i == TYPE_ENTITY then --Player, Weapon, Entity, Etc.
            
            continue
        end
        if i == TYPE_MATRIX then
            
            continue
        end
        if i == TYPE_VECTOR then --Vector or Normal
            
            continue
        end
        if i == TYPE_NUMBER then --Bit, Data, Double, Float, Int, UInt
            
            continue
        end
        if i == TYPE_STRING then
            
            continue
        end
        if i == TYPE_TABLE then
            
            continue
        end
    end

    --Write Data
    net.WriteAngle()
    net.WriteBit()
    net.WriteBool()
    net.WriteColor()
    net.WriteData()
    net.WriteDouble()
    net.WriteEntity()
    net.WriteFloat()
    net.WriteInt()
    net.WriteUInt()
    net.WriteVector()
    net.WriteMatrix()
    net.WriteNormal()
    net.WriteString()

    
end