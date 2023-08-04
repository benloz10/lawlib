
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