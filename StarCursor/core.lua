-- Create StarCursor
local StarCursor = StarCursor or {}
local frame = CreateFrame("Frame", nil, UIParent);
frame:SetFrameStrata("FULLSCREEN_DIALOG"); -- The strata as FULLSCREEN_DIALOG or DIALOG
StarCursor.texture = frame:CreateTexture();
StarCursor.texture:SetTexture([[Interface\Cooldown\star4]]);
StarCursor.texture:SetBlendMode("ADD");
StarCursor.texture:Show(); -- Ensure the texture is not hidden by default

-- Event handling
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGOUT")

eventFrame:SetScript("OnEvent", function(self, event, arg1)
  if event == "ADDON_LOADED" and arg1 == "StarCursor" then
    -- Print slash commands
    print("/starcursor - for options")
    -- Our saved variables, if they exist, have been loaded at this point.
    if StarCursorSettings then
        -- Apply the saved settings
        StarCursor.texture:SetVertexColor(StarCursorSettings.r, StarCursorSettings.g, StarCursorSettings.b, StarCursorSettings.alpha or 0.5);
    else
        -- This is the first time this addon is loaded; set SVs to default values
        StarCursorSettings = {
            r = 1,
            g = 1,
            b = 1,
            alpha = 0.5
        }
        StarCursor.texture:SetVertexColor(1, 1, 1, 0.5);
    end
  elseif event == "PLAYER_LOGOUT" then
      -- Save the current settings before logging out
      local r, g, b, alpha = StarCursor.texture:GetVertexColor()
      StarCursorSettings.r, StarCursorSettings.g, StarCursorSettings.b, StarCursorSettings.alpha = r, g, b, alpha
  end
end)

-- Constants
local MAX_SPEED = 1024;
local SPEED_DECAY = 2048;
local SIZE_MODIFIER = 6;
local MIN_SIZE = 16;

-- Initialize variables
local x, y, speed = 0, 0, 0;
x, y = GetCursorPosition(); -- Initialize with current cursor position
speed = 0; -- Initialize speed to 0

-- Function to check for NaN values
local function isnan(value)
  return value ~= value
end

-- OnUpdate function
local lastUpdate = 0
local function OnUpdate(_, elapsed)
  lastUpdate = lastUpdate + elapsed
  if lastUpdate < 0.01 then return end -- Update every 0.01 seconds
  lastUpdate = 0

  if isnan(speed) then speed = 0; end
  if isnan(x) then x = 0; end
  if isnan(y) then y = 0; end

  local prevX, prevY = x, y;
  local cursorX, cursorY = GetCursorPosition();
  local scale = UIParent:GetEffectiveScale();
  x = cursorX / scale;
  y = cursorY / scale;
  local dX, dY = x - prevX, y - prevY;

  local distance = math.sqrt(dX * dX + dY * dY);
  local decayFactor = SPEED_DECAY ^ -elapsed;
  speed = math.min(decayFactor * speed + (1 - decayFactor) * distance / elapsed, MAX_SPEED);

  local size = speed / SIZE_MODIFIER - MIN_SIZE;
  if size > 0 then
    StarCursor.texture:SetHeight(size);
    StarCursor.texture:SetWidth(size);
    StarCursor.texture:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y);
    StarCursor.texture:Show();
  else
    StarCursor.texture:Hide();
  end
end

frame:SetScript("OnUpdate", OnUpdate);
