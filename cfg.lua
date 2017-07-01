local addon, ns = ...
local E, M = unpack(_G.yaCore)
local cfg = CreateFrame("Frame")

-----------------
-- CONFIG --
-----------------

-- Hide Blizzard Stuff
cfg.channelReplacement = false
cfg.combatLogBar = false 
cfg.tabBackground = false

cfg.chatWidth = 374
cfg.chatHeight = 144

if IsAddOnLoaded("yaBars") then
	cfg.chatPos = { 200, 47 }
else
	cfg.chatPos = { 40, 110 }
end

if not IsAddOnLoaded("yaBars") and (E.Class == "HUNTER" or
									E.Class == "PALADIN" or
									E.Class == "WARLOCK" or
								   (E.Class == "MAGE" and E.Spec == 3) or
								   (E.Class == "DEATHKNIGHT" and E.Spec == 3))
then
	cfg.chatPos[2] = cfg.chatPos[2] + 35
end

cfg.barTexture = M:Fetch("yaui", "statusbar")
cfg.dropTexture = M:Fetch("yaui", "backdrop")
cfg.dropEdgeTexture = M:Fetch("yaui", "backdropEdge")

cfg.font = M:Fetch("font", "Roboto")
cfg.fontSize = M:Fetch("font", "size")

---------------
ns.cfg = cfg