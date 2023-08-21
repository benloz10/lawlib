net.Receive("lawlib_notify", function()
    local txt = net.ReadString()
    local style = net.ReadUInt(4)
    local len = net.ReadUInt(8)

    LAWLIB:Notify(txt, style, len)
end)

local NotifStyles = {
    {TxtCol = Color(255,255,255), Icon = "materials/icon16/lightbulb.png"},
    {TxtCol = Color(255,31,31), Icon = "materials/icon16/lightbulb.png"}
}

local ActiveNotifs = {}


local function addNotification(txt, style, len)
    style = math.min(style+1, #NotifStyles)
    local notif = vgui.Create("DPanel")
    notif:SetBackgroundColor(Color(40,40,40, 240))
    notif:SetSize(500, 40)
    notif.CreatedTime = CurTime()
    notif.LifeTime = len
    notif:SetPos(ScrW(), (#ActiveNotifs + 1) * 45 + 500)

    notif.Icon = vgui.Create("DImage", notif)
    notif.Icon:Dock(LEFT)
    notif.Icon:SetImage(NotifStyles[style].Icon)
    notif.Icon:SetWide(25)
    notif.Icon:DockMargin(5,5,5,5)

    notif.Text = vgui.Create("DLabel", notif)
    notif.Text:SetText(txt)
    notif.Text:SetFont("DermaLarge")
    notif.Text:SetTextColor(NotifStyles[style].TxtCol)
    notif.Text:Dock(TOP)
    notif.Text:SizeToContentsY()

    notif.TimerBar = vgui.Create("LProgress", notif)
    notif.TimerBar:Dock(BOTTOM)
    notif.TimerBar:SetFGColor(Color(0,255,0))
    notif.TimerBar:SetFraction(0)
    notif.TimerBar:SetTall(5)

    table.insert(ActiveNotifs, notif)
end

local function lawlibDrawNotification()
    if #ActiveNotifs <= 0 then return end
    local _CurTime = CurTime()
    for i=#ActiveNotifs, 1, -1 do
        local pnl = ActiveNotifs[i]
        if pnl.CreatedTime < _CurTime - pnl.LifeTime then
            table.remove(ActiveNotifs, i)
            pnl:Remove()
            continue
        end
        local remaining = _CurTime - pnl.CreatedTime
        pnl.TimerBar:SetFraction(remaining / pnl.LifeTime)
        pnl:SetX(ScrW() - (505 * math.min(remaining/0.1, 1, (pnl.LifeTime - remaining)/0.1)))
        pnl:SetY(math.Approach(pnl:GetY(), i * (pnl:GetTall() + 5) + 500, 1))
    end
end

hook.Add("HUDPaint", "lawlib_drawnotifications", lawlibDrawNotification)


function LAWLIB:Notify(txt, style, len)
    if #txt <= 0 then return end
    if style == nil then style = 0 end
    if len == nil then len = 5 end
    
    addNotification(txt, style, len)
end