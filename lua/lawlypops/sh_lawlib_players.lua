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

        if target ~= ply and
        target:Health() > 0 and
        not target:GetNoDraw() and
        distCheck and
        target:IsLineOfSightClear(ply) and
        not target:InVehicle() then
            table.insert(visible, target)
        end

        if target ~= ply and
        target:InVehicle() and
        distCheck and
        target:IsLineOfSightClear(ply) then
            local veh = target:GetVehicle()

            if veh:GetNWBool("dsit_flag") then
                table.insert(visible, target)
            end
        end
    end
    return visible
end

function LAWLIB:GetTopOfPlayer(ply, heightOffset)
    if not IsValid(ply) then return end
    if heightOffset == nil then heightOffset = 0 end
    local hMin = ply:OBBMins()
    local hMax = ply:OBBMaxs()
    local height = hMax.z - hMin.z
    local pos = ply:GetPos()
    pos.z = pos.z + hMax.z + heightOffset
    if ply.IsPony and ply:IsPony() then
        pos = pos + ply:GetUp() * (height * 0.35)
    else
        pos = pos + ply:GetUp() * (height * 0.1)
    end
    return pos
end