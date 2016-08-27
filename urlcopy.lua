
	local color = "0099FF"
	local foundurl = false
	local currentURL

  function string.color(text, color)
    return "|cff"..color..text.."|r"
  end

  function string.link(text, type, value, color)
    return "|H"..type..":"..tostring(value).."|h"..tostring(text):color(color or "ffffff").."|h"
  end

  local function highlighturl(before,url,after)
    foundurl = true
    return " "..string.link("["..url.."]", "url", url, color).." "
  end

  local function searchforurl(frame, text, ...)

    foundurl = false

    if string.find(text, "%pTInterface%p+") or string.find(text, "%pTINTERFACE%p+") then
      --disable interface textures (lol)
      foundurl = true
    end

    if not foundurl then
      --192.168.1.1:1234
      text = string.gsub(text, "(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)(%s?)", highlighturl)
    end
    if not foundurl then
      --192.168.1.1
      text = string.gsub(text, "(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)(%s?)", highlighturl)
    end
    if not foundurl then
      --www.teamspeak.com:3333
      text = string.gsub(text, "(%s?)([%w_-]+%.?[%w_-]+%.[%w_-]+:%d%d%d?%d?%d?)(%s?)", highlighturl)
    end
    if not foundurl then
      --http://www.google.com
      text = string.gsub(text, "(%s?)(%a+://[%w_/%.%?%%=~&-'%-]+)(%s?)", highlighturl)
    end
    if not foundurl then
      --www.google.com
      text = string.gsub(text, "(%s?)(www%.[%w_/%.%?%%=~&-'%-]+)(%s?)", highlighturl)
    end
    if not foundurl then
      --lol@lol.com
      text = string.gsub(text, "(%s?)([_%w-%.~-]+@[_%w-]+%.[_%w-%.]+)(%s?)", highlighturl)
    end

    frame.am(frame,text,...)

  end

  for i = 1, NUM_CHAT_WINDOWS do
    if ( i ~= 2 ) then
      local cf = _G["ChatFrame"..i]
      cf.am = cf.AddMessage
      cf.AddMessage = searchforurl
    end
  end

  local orig = ChatFrame_OnHyperlinkShow
  function ChatFrame_OnHyperlinkShow(frame, link, text, button)
    local type, value = link:match("(%a+):(.+)")
    if ( type == "url" ) then
		currentURL = value
		StaticPopup_Show("URL_COPY_DIALOG")
		return
    else
      orig(self, link, text, button)
    end
  end
  
  if not StaticPopupDialogs.URL_COPY_DIALOG then
		StaticPopupDialogs.URL_COPY_DIALOG = {
			text = "URL",
			button2 = CLOSE,
			hasEditBox = 1,
			maxLetters = 1024,
			editBoxWidth = 350,
			hideOnEscape = 1,
			showAlert = 1,
			timeout = 0,
			whileDead = 1,
			preferredIndex = 3, -- helps prevent taint; see http://forums.wowace.com/showthread.php?t=19960
			OnShow = function(self)
				(self.icon or _G[self:GetName().."AlertIcon"]):Hide()

				local editBox = self.editBox or _G[self:GetName().."EditBox"]
				editBox:SetText(currentURL)
				editBox:SetFocus()
				editBox:HighlightText(0)

				local button2 = self.button2 or _G[self:GetName().."Button2"]
				button2:ClearAllPoints()
				button2:SetPoint("TOP", editBox, "BOTTOM", 0, -6)
				button2:SetWidth(150)

				currentURL = nil
			end,
			EditBoxOnEscapePressed = function(self)
				self:GetParent():Hide()
			end,
		}
	end