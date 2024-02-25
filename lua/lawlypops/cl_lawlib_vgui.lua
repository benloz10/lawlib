local LButton = {}

function LButton:Paint(w,h)
    surface.SetDrawColor(27,27,27)
    surface.DrawRect(0,0,w,h)
    surface.SetDrawColor(97,97,97)
    surface.DrawOutlinedRect(0,0,w,h,2)
end

vgui.Register("LButton", LButton, "DButton")

local LFrame = {}
function LFrame:Init()
    self.BGColor = Color(40,40,40)
	self:SetPaintBackgroundEnabled( true )
	self:SetPaintBorderEnabled( true )

    self.DefaultText = ""
    self.HoverText = nil

    timer.Simple(FrameTime(), function()
        self:AddElements()
    end)
end

function LFrame:GetTitleHeight()
    return 30
end

function LFrame:SetTitle(txt)
    self.DefaultText = txt
end

function LFrame:SetTitleHoverText(txt)
    self.HoverText = txt
end

function LFrame:Close()
    self:Remove()
    if self.CloseSound then surface.PlaySound(self.CloseSound) end
end

function LFrame:AddElements()
    self.TitleBar = vgui.Create("DPanel", self)
    self.TitleBar:SetSize(self:GetWide(), 30)
    self.TitleBar:SetBackgroundColor(Color(56,56,56))
    
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
    self:SetBackgroundColor(Color(23,23,23))
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

    self.Bar = vgui.Create("DPanel", self)
    self.Bar:Dock(LEFT)
    self.Bar:SetWide(0)
    self.Bar:SetBackgroundColor(Color(0,255,255))
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
    self:SetBackgroundColor(Color(40,40,40))
    self:Center()
    self:AddElements()
    self:MakePopup()

    self.OutlineColor = Color(100,100,100)

    self.BGFade = vgui.Create("DPanel")
    self.BGFade:SetSize(ScrW(), ScrH())
    self.BGFade:SetBackgroundColor(Color(0,0,0,240))
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
    self.Text:SetTextColor(Color(255,255,255))
    self.Text:SetContentAlignment(8)

    self.YesBtn:SetText("Yes")
    self.YesBtn:SetFont("DermaLarge")
    self.YesBtn:SetTextColor(Color(0,200,0))
    self.YesBtn:Dock(LEFT)
    self.YesBtn:SetWide(self:GetWide()*0.4)
    self.YesBtn.OnMousePressed = function()
        if self.ConfirmAction then self:ConfirmAction() end
        self:Remove()
    end

    self.NoBtn:SetText("No")
    self.NoBtn:SetFont("DermaLarge")
    self.NoBtn:SetTextColor(Color(200,0,0))
    self.NoBtn:Dock(RIGHT)
    self.NoBtn:SetWide(self:GetWide()*0.4)
    self.NoBtn.OnMousePressed = function()
        if self.DenyAction then self:DenyAction() end
        self:Remove()
    end
end

vgui.Register("LConfirm", LConfirm, "DPanel")

local LScrollPanel = {}

function LScrollPanel:Init()
    self:InvalidateParent(true)
    self:SetMouseInputEnabled(true)
    self.movingPanel = vgui.Create("Panel", self)
    self.movingPanel:SetPos(0,0)
    self.movingPanel:SetSize(self:GetSize())

    self.ScrollOffset = 0

    self.LastMousePos = 0
    self.DeltaMouse = 0

    self.Items = {}
    self.ItemWidth = 0
    self.ItemHeight = 0
end

function LScrollPanel:Think()
    if input.IsMouseDown(MOUSE_LEFT) then
        self.DeltaMouse = gui.MouseX() - self.LastMousePos
        self.ScrollOffset = self.ScrollOffset + self.DeltaMouse
    end
    self.LastMousePos = gui.MouseX()
    self.movingPanel:SetX(self.ScrollOffset)
end

function LScrollPanel:OnMousePressed(mouseBtn)e
    if mouseBtn == MOUSE_LEFT then
    end
end

function LScrollPanel:OnMouseReleased()
end

function LScrollPanel:AddItem(panel)
    panel:SetParent(self.movingPanel)
    panel:Dock(LEFT)


    local mL, mT, mR, mB = panel:GetDockMargin()
    local mOffset = mL + mR

    self.ItemWidth = self.ItemWidth + panel:GetWide() + mOffset
    self.ItemHeight = math.max(self.ItemWidth, panel:GetTall())

    self.movingPanel:SetSize(self.ItemWidth, 2000)
    self.movingPanel:InvalidateParent(true)

    table.insert(self.Items, panel)
end

function LScrollPanel:Paint() end

function LScrollPanel:GetItems()
    return self.Items
end

function LScrollPanel:GetCanvas()
    return self.movingPanel
end

vgui.Register("LScrollPanel", LScrollPanel, "DPanel")