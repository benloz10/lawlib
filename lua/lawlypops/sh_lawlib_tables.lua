
function LAWLIB:TableWeightedSelect(tbl)
    if !tbl.TotalWeight then
        local keys = table.GetKeys(tbl)
        if !tbl[keys[1]].Weight then
            if table.IsSequential(tbl) then
                return tbl[math.random(#tbl)]
            end
            return table.Random(tbl)
        else
            LAWLIB:TableApplyWeights(tbl)
        end
    end
    local rnd = math.random() * tbl.TotalWeight
    for i, item in ipairs(tbl) do
        rnd = rnd - item.Weight
        if rnd < 0 then
            return item
        end
    end
end

function LAWLIB:TableApplyWeights(tbl)
    local total = 0
    for i, item in ipairs(tbl) do
        if !item.Weight then ErrorNoHaltWithStack("[LAWLIB] Could not apply weights to the given table. tbl.Weight returned nil") return nil end
        total = total + item.Weight
    end
    tbl.TotalWeight = total
end

function LAWLIB:NagasakiSort(tbl)
    table.Empty(tbl)
    return tbl
end