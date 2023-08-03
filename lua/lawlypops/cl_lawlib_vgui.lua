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
    self:SetBackgroundColor(Color(40,40,40))
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

    self.DefaultText = ""
    self.HoverText = nil

    timer.Simple(FrameTime(), function()
        self:AddElements()
    end)
end

function LFrame:SetTitle(txt)
    self.DefaultText = txt
end

function LFrame:SetTitleHoverText(txt)
    self.HoverText = txt
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
    self.CloseButton:SetSize(26,30)
    self.CloseButton:DockMargin(2,2,2,2)
    self.CloseButton:Dock(RIGHT)
    self.CloseButton.Root = self
    self.CloseButton:SetText("X")
    self.CloseButton:SetFont("DermaLarge")
    function self.CloseButton:OnMousePressed()
        self.Root:Remove()
        if self.Root.CloseSound then surface.PlaySound(self.Root.CloseSound) end
    end
    self:InvalidateLayout()

	self:DockPadding( 5, 30 + 5, 5, 5 )
end


function LFrame:Paint(w,h)
	local color = self:GetBackgroundColor()
	surface.SetDrawColor(color)
	surface.DrawRect(0, 0, w, h)
end

vgui.Register("LFrame", LFrame, "DPanel")

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
    self.Bar:SetWide(self:GetWide()*val)
end

function LProgress:SetFGColor(col)
    self.Bar:SetBackgroundColor(col)
end

vgui.Register("LProgress", LProgress, "DPanel")