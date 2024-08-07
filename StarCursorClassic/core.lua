StarCursor = StarCursor or {}

-- Create StarCursor
local frame = CreateFrame("Frame", nil, UIParent);
frame:SetFrameStrata("TOOLTIP");
StarCursor.texture = frame:CreateTexture();
StarCursor.texture:SetTexture([[Interface\Cooldown\star4]]);
StarCursor.texture:SetBlendMode("ADD");

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")


frame:SetScript("OnEvent", function(self, event, arg1)
  if event == "ADDON_LOADED" and arg1 == "StarCursorClassic" then
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


-- Default Texture Values
local x, y, speed = 0, 0, 0;
local MAX_SPEED = 1024;
local SPEED_DECAY = 2048;
local SIZE_MODIFIER = 6;
local MIN_SIZE = 16;

local function isNan(value)
  return value ~= value;
end

local function OnUpdate(_, elapsed)
  if isNan(speed) then speed = 0; end
  if isNan(x) then x = 0; end
  if isNan(y) then y = 0; end

  local prevX, prevY = x, y;
  x, y = GetCursorPosition();
  local dX, dY = x - prevX, y - prevY;

  local distance = math.sqrt(dX * dX + dY * dY);
  local decayFactor = SPEED_DECAY ^ -elapsed;
  speed = math.min(decayFactor * speed + (1 - decayFactor) * distance / elapsed, MAX_SPEED);

  local size = speed / SIZE_MODIFIER - MIN_SIZE;
  if size > 0 then
    local scale = UIParent:GetEffectiveScale();
    StarCursor.texture:SetHeight(size);
    StarCursor.texture:SetWidth(size);
    StarCursor.texture:SetPoint("CENTER", UIParent, "BOTTOMLEFT", (x + 0.5 * dX) / scale, (y + 0.5 * dY) / scale);
    StarCursor.texture:Show();
  else
    StarCursor.texture:Hide();
  end
end

frame:SetScript("OnUpdate", OnUpdate);
