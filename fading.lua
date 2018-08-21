local addon, ns = ...
local cfg = ns.cfg
--------------

local not_selected_tab_alpha = 1

CHAT_TAB_SHOW_DELAY = 0
CHAT_TAB_HIDE_DELAY = 0

CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 1
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 1

DEFAULT_CHATFRAME_ALPHA = 0

if cfg.tabBackground then

	local _G = _G

	local TAB_TEXTURES = {
	"Left",
	"Middle",
	"Right",
	"SelectedLeft",
	"SelectedMiddle",
	"SelectedRight",
	"Glow",
	"HighlightLeft",
	"HighlightMiddle",
	"HighlightRight",
	}

	--disable all tab textures
	for i = 1, NUM_CHAT_WINDOWS do
		for index, value in pairs(TAB_TEXTURES) do
			local texture = _G['ChatFrame'..i..'Tab'..value]
			texture:SetTexture(nil)
			end
		end
	end

	--disable tab flashing
	FCF_FlashTab = function() end
	FCFTab_UpdateAlpha = function() end

	--new fadein func
	FCF_FadeInChatFrame = function(chatFrame)
		chatFrame.hasBeenFaded = true
	end

	--new fadeout func
	FCF_FadeOutChatFrame = function(chatFrame)
		chatFrame.hasBeenFaded = false
	end

	FCFTab_UpdateColors = function(self, selected)
	if (selected) then
		self:GetFontString():SetTextColor(1,0.7,0)
		self:GetFontString():SetShadowOffset(1,-1)
		self:GetFontString():SetShadowColor(0,0,0,0.6)
		self:SetAlpha(1)
		self.leftSelectedTexture:Show();
		self.middleSelectedTexture:Show();
		self.rightSelectedTexture:Show();
	else
		self:GetFontString():SetTextColor(0.5,0.5,0.5)
		self:GetFontString():SetShadowOffset(1,-1)
		self:GetFontString():SetShadowColor(0,0,0,0.3)
		self:SetAlpha(not_selected_tab_alpha)
		self.leftSelectedTexture:Hide();
		self.middleSelectedTexture:Hide();
		self.rightSelectedTexture:Hide();
	end
end
