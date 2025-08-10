-- StarCursor Addon Core

local ADDON_NAME = ...
local StarCursor = _G.StarCursor or {}
_G.StarCursor = StarCursor

-- Create main frame
local frame = CreateFrame("Frame", nil, UIParent)
frame:SetFrameStrata("FULLSCREEN_DIALOG") -- Strata

StarCursor.texture = frame:CreateTexture()
StarCursor.texture:SetTexture([[Interface\Cooldown\star4]])
StarCursor.texture:SetBlendMode("ADD")
StarCursor.texture:Show()

-- Event handling frame
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGOUT")

eventFrame:SetScript("OnEvent", function(self, event, arg1)
  if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
    if StarCursorSettings then
      StarCursor.texture:SetVertexColor(
        StarCursorSettings.r or 1,
        StarCursorSettings.g or 1,
        StarCursorSettings.b or 1,
        StarCursorSettings.alpha or 0.5
      )
    else
      StarCursorSettings = { r = 1, g = 1, b = 1, alpha = 0.5 }
      StarCursor.texture:SetVertexColor(1, 1, 1, 0.5)
    end
  elseif event == "PLAYER_LOGOUT" then
    local r, g, b, alpha = StarCursor.texture:GetVertexColor()
    StarCursorSettings.r, StarCursorSettings.g, StarCursorSettings.b, StarCursorSettings.alpha = r, g, b, alpha
  end
end)

-- Constants
local MAX_SPEED, SPEED_DECAY, SIZE_MODIFIER, MIN_SIZE = 1024, 2048, 6, 16

-- Initialize variables
local x, y, speed = 0, 0, 0
local function SafeGetCursorPosition()
  local cx, cy = GetCursorPosition()
  if not cx or not cy then return 0, 0 end
  return cx, cy
end
x, y = SafeGetCursorPosition()
speed = 0

-- Function to check for NaN values
local function isnan(value) return value ~= value end

-- OnUpdate function
local lastUpdate, isShown = 0, false
local function OnUpdate(_, elapsed)
  lastUpdate = lastUpdate + elapsed
  if lastUpdate < 0.01 then return end
  lastUpdate = 0

  if isnan(speed) then speed = 0 end
  if isnan(x) then x = 0 end
  if isnan(y) then y = 0 end

  local prevX, prevY = x, y
  local cursorX, cursorY = SafeGetCursorPosition()
  local scale = UIParent and UIParent.GetEffectiveScale and UIParent:GetEffectiveScale() or 1
  x, y = cursorX / scale, cursorY / scale
  local dX, dY = x - prevX, y - prevY

  local distance = math.sqrt(dX * dX + dY * dY)
  local decayFactor = SPEED_DECAY ^ -elapsed
  speed = math.min(decayFactor * speed + (1 - decayFactor) * distance / elapsed, MAX_SPEED)

  local size = speed / SIZE_MODIFIER - MIN_SIZE
  if size > 0 then
    StarCursor.texture:SetSize(size, size)
    StarCursor.texture:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
    if not isShown then
      StarCursor.texture:Show()
      isShown = true
    end
  else
    if isShown then
      StarCursor.texture:Hide()
      isShown = false
    end
  end
end

frame:SetScript("OnUpdate", OnUpdate)
