local frame = CreateFrame("Frame", nil, UIParent);
frame:SetFrameStrata("TOOLTIP");
local texture = frame:CreateTexture();
texture:SetTexture([[Interface\Cooldown\star4]]);
--texture:SetVertexColor(1, 0, 0,.5);
texture:SetBlendMode("ADD");
texture:SetAlpha(0.5);
local x = 0;
local y = 0;
local speed = 0;

local function OnUpdate(_, elapsed)
  --Somehow speed or something else is getting to -nan, reset if so (temporary fix by raymar_of_brovaria)
  if speed + 1 == speed then
    speed = 0
  end
  if x + 1 == x then
    x = 0
  end
  if y + 1 == y then
    y = 0
  end
  --end of temp fix
--local function OnUpdate(_, elapsed)
  local dX = x;
  local dY = y;
  x, y = GetCursorPosition();
  dX = x - dX;
  dY = y - dY;
  local weight = 2048 ^ -elapsed;
  speed = math.min(weight * speed + (1 - weight) * math.sqrt(dX * dX + dY * dY) / elapsed, 1024);
  local size = speed / 6 - 16;
  if (size > 0) then
    local scale = UIParent:GetEffectiveScale();
    texture:SetHeight(size);
    texture:SetWidth(size);
    texture:SetPoint("CENTER", UIParent, "BOTTOMLEFT", (x + 0.5 * dX) / scale, (y + 0.5 * dY) / scale);
    texture:Show();
  else
    texture:Hide();
  end
end
frame:SetScript("OnUpdate", OnUpdate);
