
function LAWLIB:GetTimePhrase(lower)
    local time = tonumber(os.date("%H"))
    local phrase = "Evening"
    if time < 18 then
        phrase = "Afternoon"
    elseif time <= 12 then
        phrase = "Morning"
    end
    if lower then phrase = string.lower(phrase) end
    return phrase
end

function LAWLIB:GetTimeText(time)
    local timeTable = string.FormattedTime(time)
    local timeString = ""

    local d = math.floor(timeTable.h / 24)
    timeTable.h = timeTable.h % 24
    if d > 0 then
        timeString = timeString .. d .. " day"
        if d > 1 then
            timeString = timeString .. "s"
        end
    end
    if timeTable.h > 0 then
        if #timeString > 0 then timeString = timeString .. ", " end
        timeString = timeString .. timeTable.h .. " hour"
        if timeTable.h > 1 then
            timeString = timeString .. "s"
        end
    end
    if timeTable.m > 0 then
        if #timeString > 0 then timeString = timeString .. ", " end
        timeString = timeString .. timeTable.m .. " minute"
        if timeTable.m > 1 then
            timeString = timeString .. "s"
        end
    end
    if timeTable.s > 0 then
        if #timeString > 0 then timeString = timeString .. ", " end
        timeString = timeString .. timeTable.s .. " second"
        if timeTable.s > 1 then
            timeString = timeString .. "s"
        end
    end

    return timeString
end