local LButton = {}

function LButton:Init()
    self.HoverColor = LAWLIB.Col.HoverColor
    self.DefaultColor = LAWLIB.Col.White
    self.BackgroundColor = LAWLIB.Col.DarkBackground
    self.OutlineColor = LAWLIB.Col.Highlight
    self.SuccessSound = "buttons/button15.wav"
    self.FailSound = "buttons/blip16.wav"
end

AccessorFunc(LButton, "HoverColor", "HoverColor", FORCE_COLOR)
AccessorFunc(LButton, "DefaultColor", "DefaultColor", FORCE_COLOR)
AccessorFunc(LButton, "BackgroundColor", "BackgroundColor", FORCE_COLOR)
AccessorFunc(LButton, "OutlineColor", "OutlineColor", FORCE_COLOR)

function LButton:Paint(w,h)
    surface.SetDrawColor(self.BackgroundColor)
    surface.DrawRect(0,0,w,h)
    surface.SetDrawColor(self.OutlineColor)
    surface.DrawOutlinedRect(0,0,w,h,2)
    if self:IsHovered() and self:GetTextColor() ~= self.HoverColor then
        self:SetTextColor(self.HoverColor)
    elseif not self:IsHovered() and self:GetTextColor() ~= self.DefaultColor then
        self:SetTextColor(self.DefaultColor)
    end
end

vgui.Register("LButton", LButton, "DButton")

local LFrame = {}
function LFrame:Init()
    self.BGColor = LAWLIB.Col.Background
	self:SetPaintBackgroundEnabled( true )
	self:SetPaintBorderEnabled( true )

    self.DefaultText = ""
    self.HoverText = nil

    timer.Simple(FrameTime(), function()
        if not IsValid(self) then return end
        self:AddElements()
    end)
end

function LFrame:GetTitleHeight()
    return 30
end

function LFrame:SetTitle(txt)
    self.DefaultText = txt
    if IsValid(self.TitleText) then
        self.TitleText:SetText(txt)
    end
end

function LFrame:SetTitleHoverText(txt)
    self.HoverText = txt
end

function LFrame:Close()
    self:Remove()
    if self.CloseSound then surface.PlaySound(self.CloseSound) end
end

function LFrame:LoadDefault()
    self:ParentToHUD()
    self:SetSize(ScrW()*0.8, ScrH()*0.8)
    self:SetTitle("Default Title")
    self:MakePopup()
    self:Center()
end

function LFrame:AddElements()
    self.TitleBar = vgui.Create("DPanel", self)
    self.TitleBar:SetSize(self:GetWide(), 30)
    self.TitleBar:SetBackgroundColor(LAWLIB.Col.TitleBar)
    
    self.TitleText = vgui.Create("DLabel", self.TitleBar)
    self.TitleText:SetFont("DermaLarge")
    self.TitleText:SetText(self.DefaultText)
    self.TitleText:SizeToContents()
    self.TitleText:SetContentAlignment(5)
    self.TitleText:Center()
    self.TitleText:SetMouseInputEnabled(true)
    self.TitleText.CurState = 0
    self.TitleText.Root = self
    function self.TitleText:Think()
        if self.Root.HoverText == nil then return end
        if self:IsHovered() then
            if self.CurState == 0 then
            self:SetText(self.Root.HoverText)
            self.CurState = 1
            end
        else
            if self.CurState != 0 then
            self:SetText(self.Root.DefaultText)
            self.CurState = 0
            end
        end
    end

    self.CloseButton = vgui.Create("LButton", self.TitleBar)
    self.CloseButton:SetSize(27,30)
    self.CloseButton:DockMargin(2,2,2,2)
    self.CloseButton:Dock(RIGHT)
    self.CloseButton.Root = self
    self.CloseButton:SetText("X")
    self.CloseButton:SetFont("LAWLIB:Monospace:Large")
    self.CloseButton:SetContentAlignment(5)
    function self.CloseButton:OnMousePressed()
        self.Root:Close()
    end
    self:InvalidateLayout()

	self:DockPadding( 5, 30 + 5, 5, 5 )
end


function LFrame:Paint(w,h)
	surface.SetDrawColor(self.BGColor)
	surface.DrawRect(0, 0, w, h)
end

vgui.Register("LFrame", LFrame, "EditablePanel")

local LProgress = {}

function LProgress:Init()
    self:SetBackgroundColor(LAWLIB.Col.DarkBackground)
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

    self.Bar = vgui.Create("DPanel", self)
    self.Bar:Dock(LEFT)
    self.Bar:SetWide(0)
    self.Bar:SetBackgroundColor(LAWLIB.Col.Cyan)
end

function LProgress:SetFraction(val)
    if val == nil then val = 0 end
    val = math.Clamp(val, 0, 1)
    self.Bar:SetWide(self:GetWide()*val)
end

function LProgress:SetFGColor(col)
    self.Bar:SetBackgroundColor(col)
end

vgui.Register("LProgress", LProgress, "DPanel")

local LConfirm = {}

function LConfirm:Init()
    self:SetSize(ScrW()*0.3, ScrW()*0.07)
    self:DockPadding(10,10,10,10)
    self:SetBackgroundColor(LAWLIB.Col.Background)
    self:Center()
    self:AddElements()
    self:MakePopup()

    self.OutlineColor = LAWLIB.Col.Highlight

    self.BGFade = vgui.Create("DPanel")
    self.BGFade:SetSize(ScrW(), ScrH())
    self.BGFade:SetBackgroundColor(LAWLIB.Col.TransparentBackground)
end

function LConfirm:OnRemove()
    self.BGFade:Remove()
end

function LConfirm:Paint(w,h)
    surface.SetDrawColor(self:GetBackgroundColor())
    surface.DrawRect(0,0,w,h)
    surface.SetDrawColor(self.OutlineColor)
    surface.DrawOutlinedRect(0,0,w,h,4)
end

function LConfirm:SetTitle(txt)
    self.Text:SetText(txt)
end
function LConfirm:SetTitleColor(col)
    self.Text:SetTextColor(col)
end
function LConfirm:SetConfirmText(txt)
    self.YesBtn:SetText(txt)
end
function LConfirm:SetDenyText(txt)
    self.NoBtn:SetText(txt)
end
function LConfirm:GetLabel()
    return self.Text
end
function LConfirm:GetConfirmButton()
    return self.YesBtn
end
function LConfirm:GetDenyButton()
    return self.NoBtn
end

function LConfirm:AddElements()
    self.Text = vgui.Create("DLabel", self)
    self.YesBtn = vgui.Create("LButton", self)
    self.NoBtn = vgui.Create("LButton", self)

    self.Text:DockMargin(5,5,5,10)
    self.Text:Dock(TOP)
    self.Text:SetTall(self:GetTall()*0.5)
    self.Text:SetContentAlignment(7)

    self.Text:SetText("Are you sure?")
    self.Text:SetFont("DermaLarge")
    self.Text:SetTextColor(LAWLIB.Col.White)
    self.Text:SetContentAlignment(8)

    self.YesBtn:SetText("Yes")
    self.YesBtn:SetFont("DermaLarge")
    self.YesBtn:SetTextColor(LAWLIB.Col.DarkGreen)
    self.YesBtn:Dock(LEFT)
    self.YesBtn:SetWide(self:GetWide()*0.4)
    self.YesBtn.OnMousePressed = function()
        surface.PlaySound(self.NoBtn.SuccessSound)
        if self.ConfirmAction then self:ConfirmAction() end
        self:Remove()
    end

    self.NoBtn:SetText("No")
    self.NoBtn:SetFont("DermaLarge")
    self.NoBtn:SetTextColor(LAWLIB.Col.DarkRed)
    self.NoBtn:Dock(RIGHT)
    self.NoBtn:SetWide(self:GetWide()*0.4)
    self.NoBtn.OnMousePressed = function()
        surface.PlaySound(self.NoBtn.SuccessSound)
        if self.DenyAction then self:DenyAction() end
        self:Remove()
    end
end

vgui.Register("LConfirm", LConfirm, "DPanel")

local LScrollPanel = {}

function LScrollPanel:Init()
    self:InvalidateParent(true)
    self:SetMouseInputEnabled(true)

    self.Spacing = 5

    self.ScrollLimit = 0

    self.ScrollOffset = 0
    self.SmoothScrollOffset = 0
    self.MaxScroll = 100
    self.FirstSelect = true

    self.LastMousePos = 0
    self.DeltaMouse = 0

    self.Items = {}
    self.ItemWidth = 0
    self.ItemHeight = 0
end

function LScrollPanel:Think()
    if (self:IsHovered() or self:IsChildHovered()) and input.IsMouseDown(MOUSE_LEFT) then
        self.DeltaMouse = gui.MouseX() - self.LastMousePos
        self.ScrollOffset = self.ScrollOffset + self.DeltaMouse
    end
    self.ScrollOffset = math.Clamp(self.ScrollOffset, -self.MaxScroll + self.ScrollLimit*1.4, ScrW() - self.ScrollLimit)

    self.LastMousePos = gui.MouseX()
    self.SmoothScrollOffset = math.Approach(self.SmoothScrollOffset, self.ScrollOffset, math.abs(self.SmoothScrollOffset - self.ScrollOffset)/10)
    for i, panel in ipairs(self.Items) do
        if not IsValid(panel) then continue end
        panel:SetX(self.SmoothScrollOffset + (self.Spacing+panel:GetWide())*(i-1))
    end
end

function LScrollPanel:OnMouseWheeled(delta)
    self.ScrollOffset = self.ScrollOffset + delta*200
end

function LScrollPanel:OnMousePressed(mouseBtn)
    if mouseBtn == MOUSE_LEFT then
    end
end

function LScrollPanel:OnMouseReleased()
end

AccessorFunc(LScrollPanel, "Spacing", "Spacing", FORCE_NUMBER)

function LScrollPanel:AddItem(panel)
    panel:SetParent(self)
    panel:SetTall(self:GetTall())
    panel.ScrollPanelIndex = #self.Items+1
    panel.MouseStart = 0
    
    panel:SetMouseInputEnabled(true)
    if panel.OnMousePressed then panel.oldMousePressed = panel.OnMousePressed end

    function panel:OnMousePressed(mbutton)
        if panel.oldMousePressed then panel:oldMousePressed(mbutton) end
        panel.oldmousePressed = nil
        self.MouseStart = gui.MouseX()
    end
    function panel:OnMouseReleased()
        if math.abs(self.MouseStart - gui.MouseX()) > 10 then return end
        panel:GetParent():Select(self.ScrollPanelIndex)
    end

    self.MaxScroll = self.MaxScroll + panel:GetWide() + self.Spacing

    self.ScrollLimit = math.max(self.ScrollLimit, panel:GetWide() + self.Spacing)

    table.insert(self.Items, panel)
end

function LScrollPanel:Select(index)
    if index < 1 or index > #self.Items then return false end
    self.ScrollOffset = ScrW()/2 - (self.Spacing+self.Items[index]:GetWide()) * (index-1) - self.Items[index]:GetWide()/2
    if self.FirstSelect then
        self.SmoothScrollOffset = self.ScrollOffset
        self.FirstSelect = false
    end
    local item = self.Items[index]
    if item.OnSelect then
        item:OnSelect()
    end
    return self.Items[index]
end

function LScrollPanel:SelectPanel(panel)
    for i, item in ipairs(self.Items) do
        if item ~= panel then continue end
        self:Select(i)
        return i
    end
    return false
end

function LScrollPanel:Paint() end

function LScrollPanel:GetItems()
    return self.Items
end

vgui.Register("LScrollPanel", LScrollPanel, "Panel")