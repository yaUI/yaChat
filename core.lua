local addon, ns = ...
local E, M = unpack(_G.yaCore)
local cfg = ns.cfg
local lib = ns.lib
--------------

E:SkinFrame(ChatFrame1)
E:SkinFrame(ChatFrame3)

CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}
ChatTypeInfo.WHISPER.sticky = 1
ChatTypeInfo.OFFICER.sticky = 1
ChatTypeInfo.CHANNEL.sticky = 1

--hide the menu button
ChatFrameMenuButton:HookScript("OnShow", ChatFrameMenuButton.Hide)
ChatFrameMenuButton:Hide()

--hide the friend micro button
QuickJoinToastButton:HookScript("OnShow", QuickJoinToastButton.Hide)
QuickJoinToastButton:Hide()

--don't cut the toastframe
BNToastFrame:SetClampedToScreen(true)
BNToastFrame:SetClampRectInsets(-15,15,15,-15)

local _G = _G
local gsub = _G.string.gsub
local ChatFrame_AddMessageGroup = ChatFrame_AddMessageGroup
local ChatFrame_RemoveAllMessageGroups = ChatFrame_RemoveAllMessageGroups
local ChatFrame_AddChannel = ChatFrame_AddChannel
local ChatFrame_RemoveChannel = ChatFrame_RemoveChannel
local ChangeChatColor = ChangeChatColor
local ToggleChatColorNamesByClassGroup = ToggleChatColorNamesByClassGroup
local FCF_ResetChatWindows = FCF_ResetChatWindows
local FCF_SetLocked = FCF_SetLocked
local FCF_DockFrame, FCF_UnDockFrame = FCF_DockFrame, FCF_UnDockFrame
local FCF_OpenNewWindow = FCF_OpenNewWindow
local FCF_SavePositionAndDimensions = FCF_SavePositionAndDimensions
local FCF_GetChatWindowInfo = FCF_GetChatWindowInfo
local FCF_SetWindowName = FCF_SetWindowName
local FCF_StopDragging = FCF_StopDragging
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local LOOT, GENERAL, TRADE = LOOT, GENERAL, TRADE

CHAT_FLAG_GM = "GM "
CHAT_BN_WHISPER_INFORM_GET = "To: %s: "
CHAT_BN_WHISPER_GET = "From: %s: "
CHAT_RAID_WARNING_GET = "%s "

local tabs = {"Left", "Middle", "Right", "SelectedLeft", "SelectedMiddle",
	"SelectedRight", "Glow", "HighlightLeft", "HighlightMiddle", 
	"HighlightRight"}

local frame = CreateFrame("FRAME", nil); -- Frame to respond to events
frame:RegisterEvent("PLAYER_ENTERING_WORLD");  -- fired any time the player enters or exits the world, ie any time the player sees a loading screen

local function eventHandler(self, event, ...)
		FCF_ResetChatWindows()
		FCF_UnDockFrame(ChatFrame2)

		FCF_OpenNewWindow(LOOT)
		FCF_UnDockFrame(ChatFrame3)
		ChatFrame3:Show()

		for i = 1, NUM_CHAT_WINDOWS do

			_G["ChatFrame"..i]:ClearAllPoints()
			_G["ChatFrame"..i]:SetMovable(true)
			_G["ChatFrame"..i]:SetUserPlaced(true)
			_G["ChatFrame"..i]:SetHeight(cfg.chatHeight)
			_G["ChatFrame"..i]:SetWidth(cfg.chatWidth)
			-- move general bottom left
			if i == 3 then
				_G["ChatFrame"..i]:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", cfg.chatPos[1], cfg.chatPos[2])
			else
				_G["ChatFrame"..i]:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", cfg.chatPos[1]*-1, cfg.chatPos[2])
			end
			FCF_SavePositionAndDimensions(_G["ChatFrame"..i])
			FCF_StopDragging(_G["ChatFrame"..i])
			FCF_SetLocked(_G["ChatFrame"..i], 1)
			
			-- rename windows general because moved to chat #3
			if i == 1 then
				FCF_SetWindowName(_G["ChatFrame"..i], GENERAL)
			elseif i == 2 then
				FCF_SetWindowName(_G["ChatFrame"..i], GUILD_EVENT_LOG)
			elseif i == 3 then 
				FCF_SetWindowName(_G["ChatFrame"..i], LOOT.." / "..TRADE) 
			end
			
			ChatFrame_RemoveAllMessageGroups(ChatFrame1)
			
			ChatFrame_RemoveChannel(ChatFrame1, GENERAL)
			ChatFrame_RemoveChannel(ChatFrame1, "LocalDefense")
			ChatFrame_RemoveChannel(ChatFrame1, TRADE)
			
			ChatFrame_AddMessageGroup(ChatFrame1, "GUILD")
			ChatFrame_AddMessageGroup(ChatFrame1, "OFFICER")
			ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_ACHIEVEMENT")
			ChatFrame_AddMessageGroup(ChatFrame1, "WHISPER")
			ChatFrame_AddMessageGroup(ChatFrame1, "PARTY")
			ChatFrame_AddMessageGroup(ChatFrame1, "PARTY_LEADER")
			ChatFrame_AddMessageGroup(ChatFrame1, "RAID")
			ChatFrame_AddMessageGroup(ChatFrame1, "RAID_LEADER")
			ChatFrame_AddMessageGroup(ChatFrame1, "RAID_WARNING")
			ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT")
			ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT_LEADER")
			ChatFrame_AddMessageGroup(ChatFrame1, "SYSTEM")
			ChatFrame_AddMessageGroup(ChatFrame1, "ERRORS")
			ChatFrame_AddMessageGroup(ChatFrame1, "AFK")
			ChatFrame_AddMessageGroup(ChatFrame1, "DND")
			ChatFrame_AddMessageGroup(ChatFrame1, "IGNORED")
			ChatFrame_AddMessageGroup(ChatFrame1, "ACHIEVEMENT")
			ChatFrame_AddMessageGroup(ChatFrame1, "BN_WHISPER")
			ChatFrame_AddMessageGroup(ChatFrame1, "BN_CONVERSATION")
			ChatFrame_AddMessageGroup(ChatFrame1, "BN_INLINE_TOAST_ALERT")
			
			
			
			ChatFrame_RemoveAllMessageGroups(ChatFrame3)

			if not IsInRaid() then
				ChatFrame_AddChannel(ChatFrame3, GENERAL)
			else
				E:Print("Detected Raid group, not registering to General chat.")
			end
			ChatFrame_AddChannel(ChatFrame3, TRADE)
			
			ChatFrame_AddMessageGroup(ChatFrame3, "MONSTER_SAY")
			ChatFrame_AddMessageGroup(ChatFrame3, "MONSTER_EMOTE")
			ChatFrame_AddMessageGroup(ChatFrame3, "MONSTER_YELL")
			ChatFrame_AddMessageGroup(ChatFrame3, "MONSTER_BOSS_EMOTE")
			ChatFrame_AddMessageGroup(ChatFrame3, "SAY")
			ChatFrame_AddMessageGroup(ChatFrame3, "EMOTE")
			ChatFrame_AddMessageGroup(ChatFrame3, "YELL")
			ChatFrame_AddMessageGroup(ChatFrame3, "BG_HORDE")
			ChatFrame_AddMessageGroup(ChatFrame3, "BG_ALLIANCE")
			ChatFrame_AddMessageGroup(ChatFrame3, "BG_NEUTRAL")
			ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_FACTION_CHANGE")
			ChatFrame_AddMessageGroup(ChatFrame3, "SKILL")
			ChatFrame_AddMessageGroup(ChatFrame3, "LOOT")
			ChatFrame_AddMessageGroup(ChatFrame3, "MONEY")
			ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_XP_GAIN")
			ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_HONOR_GAIN")
			ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_GUILD_XP_GAIN")
			ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_MISC_INFO")
			
			ToggleChatColorNamesByClassGroup(true, "SAY")
			ToggleChatColorNamesByClassGroup(true, "EMOTE")
			ToggleChatColorNamesByClassGroup(true, "YELL")
			ToggleChatColorNamesByClassGroup(true, "GUILD")
			ToggleChatColorNamesByClassGroup(true, "OFFICER")
			ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
			ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
			ToggleChatColorNamesByClassGroup(true, "WHISPER")
			ToggleChatColorNamesByClassGroup(true, "PARTY")
			ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
			ToggleChatColorNamesByClassGroup(true, "RAID")
			ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
			ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
			ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
			ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")	
			ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
			ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")	
			ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL6")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL7")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL8")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL9")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL10")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL11")
			
			-- Adjust Chat Colors
			ChangeChatColor("CHANNEL1", 195/255, 230/255, 232/255) -- General
			ChangeChatColor("CHANNEL2", 232/255, 158/255, 121/255) -- Trade
			ChangeChatColor("CHANNEL3", 232/255, 228/255, 121/255) -- Local Defense
			
			local cf = 'ChatFrame'..i
			local tex = _G[cf..'EditBox']:GetRegions()
			
			_G[cf..'ButtonFrame'].Show = _G[cf..'ButtonFrame'].Hide
			_G[cf..'ButtonFrame']:Hide()
			
			_G[cf..'EditBox']:SetAltArrowKeyMode(false)
			_G[cf..'EditBox']:ClearAllPoints()
			_G[cf..'EditBox']:SetPoint('BOTTOMLEFT', ChatFrame1, 'TOPLEFT', -4, 6)
			_G[cf..'EditBox']:SetPoint('TOPRIGHT', _G.ChatFrame1, 'TOPRIGHT', 6, 30)
			_G[cf..'EditBox']:SetShadowOffset(0, 0)

			E:SkinBackdrop(_G[cf..'EditBox'])

			_G[cf..'EditBox']:HookScript("OnEditFocusGained", function(self) self:Show() end)
			_G[cf..'EditBox']:HookScript("OnEditFocusLost", function(self) self:Hide() end)
			_G[cf..'EditBoxHeader']:SetShadowOffset(0, 0)
			
			_G[cf.."Tab"]:HookScript("OnClick", function() _G[cf.."EditBox"]:Hide() end)

			_G[cf.."EditBoxLeft"]:Hide()
			_G[cf.."EditBoxRight"]:Hide()
			_G[cf.."EditBoxMid"]:Hide()
			_G[cf.."EditBoxFocusLeft"]:SetTexture(nil)
			_G[cf.."EditBoxFocusRight"]:SetTexture(nil)
			_G[cf.."EditBoxFocusMid"]:SetTexture(nil)

			_G[cf..'EditBox']:SetFont(cfg.font, 12)

			_G[cf]:SetFont(cfg.font, 12)

			--hooksecurefunc("FloatingChatFrame_Update",function(id, ...)
			--	_G["ChatFrame"..id]:SetFont(cfg.font, 12)
			--end)
			_G[cf..'EditBox']:Hide()

			_G[cf]:SetMinResize(0,0)
			_G[cf]:SetMaxResize(0,0)
			_G[cf]:SetFading(true)	
			_G[cf]:SetClampRectInsets(0,0,0,0)
			_G[cf]:SetShadowOffset(1, 1)
			_G[cf..'ResizeButton']:SetPoint("BOTTOMRIGHT", cf, "BOTTOMRIGHT", 9,-5)
			_G[cf..'ResizeButton']:SetScale(.4)
			_G[cf..'ResizeButton']:SetAlpha(0.5)
			
			for g = 1, #CHAT_FRAME_TEXTURES do
				_G["ChatFrame"..i..CHAT_FRAME_TEXTURES[g]]:SetTexture(nil)
			end
			for index, value in pairs(tabs) do
				local texture = _G['ChatFrame'..i..'Tab'..value]
				texture:SetTexture(nil)
			end
		end

		if cfg.combatLogBar then
			local EventFrame = CreateFrame("Frame");
			EventFrame:RegisterEvent("ADDON_LOADED");
			local function EventHandler(self, event, ...)
				if ... == "Blizzard_CombatLog" then
					local topbar = _G["CombatLogQuickButtonFrame_Custom"];
					if not topbar then return end
					topbar:Hide();
					topbar:HookScript("OnShow", function(self) topbar:Hide(); end);
					topbar:SetHeight(0);
				end
			end
			EventFrame:SetScript("OnEvent", EventHandler);
		end

		FCF_DockFrame(ChatFrame2)
end
frame:SetScript("OnEvent", eventHandler); -- frame script that begins running the on event handler