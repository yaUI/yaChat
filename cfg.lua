local addon, ns = ...
local E, M = unpack(_G.vCore)
local cfg = CreateFrame("Frame")
--------------

-- Hide Blizzard Stuff
cfg.channelReplacement = false
cfg.combatLogBar = false 
cfg.tabBackground = false

cfg.chatWidth = 374
cfg.chatHeight = 144

if IsAddOnLoaded("vBars") then
	cfg.chatPos = { 200, 47 }
else
	cfg.chatPos = { 40, 110 }
end

if not IsAddOnLoaded("vBars") and (E.Class == "HUNTER" or
									E.Class == "PALADIN" or
									E.Class == "WARLOCK" or
								   (E.Class == "MAGE" and E.Spec == 3) or
								   (E.Class == "DEATHKNIGHT" and E.Spec == 3))
then
	cfg.chatPos[2] = cfg.chatPos[2] + 35
end

cfg.barTexture = M:Fetch("vui", "statusbar")
cfg.dropTexture = M:Fetch("vui", "backdrop")
cfg.dropEdgeTexture = M:Fetch("vui", "backdropEdge")

cfg.font = M:Fetch("font", "Roboto")
cfg.fontSize = M:Fetch("font", "size")

---------------
ns.cfg = cfg