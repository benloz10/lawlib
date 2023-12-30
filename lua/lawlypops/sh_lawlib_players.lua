function LAWLIB:GetVisiblePlayers(ply, dist)
    if not IsValid(ply) then return {} end
    if dist == nil then dist = 0 end
    local plyList = player.GetAll()
    local visible = {}
    --Avoid doing root operations in per-frame hooks.
    local maxviewDist = dist * dist

    for i=1, #plyList do
        local target = plyList[i]
        
        local distCheck = true
        if dist > 0 and ply:GetPos():DistToSqr(target:GetPos()) > maxviewDist then
            distCheck = false
        end

        local target = plyList[i]
        if target ~= ply and
        distCheck and
        target:IsLineOfSightClear(ply) and
        target:Health() > 0 and
        not target:InVehicle() then
            table.insert(visible, target)
        end
    end
    return visible
end

function LAWLIB:GetTopOfPlayer(ply, heightOffset)
    if not IsValid(ply) then return end
    if heightOffset == nil then heightOffset = 0 end
    local hMin = ply:OBBMins()
    local hMax = ply:OBBMaxs()
    local height = hMax.z - hMin.z + heightOffset
    local pos = ply:GetPos()
    pos.z = pos.z + hMax.z
    if ply:IsPony() then
        pos = pos + ply:GetUp() * (height * 0.35)
    end
    return pos
end