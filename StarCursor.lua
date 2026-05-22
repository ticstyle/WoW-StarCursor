local addonName = "StarCursor"
local baseSize = 32
local trailSize = 20
local optionsCategory

-- Default Settings
local defaultSettings = {
    scale = 2.2,
    alpha = 1.0,
    trail = true,
    r = 1, g = 1, b = 1,
    texture = "Star (Default)",
    trailTexture = "Match Cursor"
}

local currentTexturePath = "Interface\\Cooldown\\star4"

-- Main Icon List
local textureList = {
    {name="Star (Default)", path="Interface\\Cooldown\\star4"},
    {name="Ring", path="Interface\\Cooldown\\ping4"},
    {name="Dot", path="Interface\\COMMON\\Indicator-Gray"},
}

-- Trail Style List
local trailTextureList = {
    {name="Match Cursor", path="MATCH"},
    {name="Star", path="Interface\\Cooldown\\star4"},
    {name="Ring", path="Interface\\Cooldown\\ping4"},
    {name="Dot", path="Interface\\COMMON\\Indicator-Gray"},
}

local function GetTexturePath(name)
    for _, data in ipairs(textureList) do
        if data.name == name then return data.path end
    end
    return textureList[1].path
end

local function GetTrailTexturePath(name)
    for _, data in ipairs(trailTextureList) do
        if data.name == name then return data.path end
    end
    return "MATCH"
end

-- 1. Main Frame
local frame = CreateFrame("Frame", "StarCursorMain", UIParent)
frame:SetSize(baseSize, baseSize)
frame:SetFrameStrata("TOOLTIP")
frame:SetIgnoreParentAlpha(true)
local tex = frame:CreateTexture(nil, "OVERLAY")
tex:SetAllPoints()
frame.tex = tex

-- 2. Trail Frames
local trails = {}
for i = 1, 40 do
    local t = CreateFrame("Frame", nil, UIParent)
    t:SetSize(trailSize, trailSize)
    t:SetFrameStrata("TOOLTIP")
    t.tex = t:CreateTexture(nil, "OVERLAY")
    t.tex:SetAllPoints()
    t:Hide()
    trails[i] = t
end

-- 3. Update Visuals
local function UpdateVisuals()
    if not StarCursorDB then return end
    
    currentTexturePath = GetTexturePath(StarCursorDB.texture)
    
    frame:SetAlpha(StarCursorDB.alpha or 1)
    frame.tex:SetTexture(currentTexturePath)
    frame.tex:SetVertexColor(StarCursorDB.r or 1, StarCursorDB.g or 1, StarCursorDB.b or 1)
    frame.tex:SetBlendMode("ADD")
end

-- 4. Animation Variables
local currentVisualScale = 0
local lastX, lastY = 0, 0

-- 5. Main Loop
frame:SetScript("OnUpdate", function(self, elapsed)
    if not StarCursorDB then return end
    
    local x, y = GetCursorPosition()
    local uiscale = UIParent:GetEffectiveScale()
    if uiscale == 0 then uiscale = 1 end
    x = x / uiscale
    y = y / uiscale
    
    frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
    
    local dist = math.sqrt((x - lastX)^2 + (y - lastY)^2)
    
    -- Speed Scale Logic
    local speedFactor = math.min(dist / 15, 1.0)
    local targetScale = (StarCursorDB.scale or 1) * speedFactor
    
    local smoothSpeed = (targetScale > currentVisualScale) and 15 or 5
    currentVisualScale = currentVisualScale + (targetScale - currentVisualScale) * (elapsed * smoothSpeed)
    
    if currentVisualScale < 0.05 then currentVisualScale = 0 end
    frame:SetSize(baseSize * currentVisualScale, baseSize * currentVisualScale)

    -- Trail Logic
    if StarCursorDB.trail and currentVisualScale > 0.2 and dist > 3 then
        local t = trails[1]
        table.remove(trails, 1) 
        
        t:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
        
        local trailScale = currentVisualScale * 0.6
        t:SetSize(trailSize * trailScale, trailSize * trailScale)
        
        -- Trail Texture Selection
        local selectedTrailStyle = StarCursorDB.trailTexture or "Match Cursor"
        local trailPathToUse
        
        if selectedTrailStyle == "Match Cursor" then
            trailPathToUse = currentTexturePath
        else
            trailPathToUse = GetTrailTexturePath(selectedTrailStyle)
            if trailPathToUse == "MATCH" then trailPathToUse = currentTexturePath end
        end

        t.tex:SetTexture(trailPathToUse)
        t.tex:SetVertexColor(StarCursorDB.r or 1, StarCursorDB.g or 1, StarCursorDB.b or 1, 1.0)
        t.tex:SetBlendMode("ADD")
        
        local startAlpha = (StarCursorDB.alpha or 1) * 0.6 
        t:SetAlpha(startAlpha) 
        t:Show()
        
        UIFrameFadeOut(t, 0.5, startAlpha, 0)
        
        table.insert(trails, t)
    end
    
    lastX, lastY = x, y
end)

-- 6. Color Picker
local function OpenColorPicker()
    local function ColorCallback()
        local r, g, b = ColorPickerFrame:GetColorRGB()
        StarCursorDB.r, StarCursorDB.g, StarCursorDB.b = r, g, b
        UpdateVisuals()
    end

    if ColorPickerFrame.SetupColorPickerAndShow then
        ColorPickerFrame:SetupColorPickerAndShow({
            r = StarCursorDB.r, g = StarCursorDB.g, b = StarCursorDB.b,
            swatchFunc = ColorCallback
        })
    else
        ColorPickerFrame.func = ColorCallback
        ColorPickerFrame:SetColorRGB(StarCursorDB.r, StarCursorDB.g, StarCursorDB.b)
        ColorPickerFrame:Show()
    end
end

-- 7. Settings UI
local panel = CreateFrame("Frame", "StarCursorOptions", UIParent)
panel.name = "StarCursor"

local function InitOptions()
    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("StarCursor Settings")

    -- Trail Checkbox
    local trailBtn = CreateFrame("CheckButton", "StarCursorTrailCheck", panel, "InterfaceOptionsCheckButtonTemplate")
    trailBtn:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -20)
    _G[trailBtn:GetName() .. "Text"]:SetText("Enable Trail")
    trailBtn:SetChecked(StarCursorDB.trail)
    trailBtn:SetScript("OnClick", function(self) StarCursorDB.trail = self:GetChecked() end)

    -- Scale Slider
    local scaleSlider = CreateFrame("Slider", "StarCursorScale", panel, "OptionsSliderTemplate")
    scaleSlider:SetPoint("TOPLEFT", trailBtn, "BOTTOMLEFT", 0, -40)
    scaleSlider:SetMinMaxValues(0.2, 5.0)
    scaleSlider:SetValueStep(0.1)
    scaleSlider:SetObeyStepOnDrag(true)
    _G[scaleSlider:GetName() .. "Text"]:SetText("Max Size (At Full Speed)")
    scaleSlider:SetValue(StarCursorDB.scale)
    scaleSlider:SetScript("OnValueChanged", function(self, value)
        StarCursorDB.scale = value
        currentVisualScale = value
        UpdateVisuals()
    end)
    
    -- Alpha Slider
    local alphaSlider = CreateFrame("Slider", "StarCursorAlpha", panel, "OptionsSliderTemplate")
    alphaSlider:SetPoint("TOPLEFT", scaleSlider, "BOTTOMLEFT", 0, -40)
    alphaSlider:SetMinMaxValues(0.1, 1.0)
    alphaSlider:SetValueStep(0.1)
    scaleSlider:SetObeyStepOnDrag(true)
    _G[alphaSlider:GetName() .. "Text"]:SetText("Transparency")
    alphaSlider:SetValue(StarCursorDB.alpha)
    alphaSlider:SetScript("OnValueChanged", function(self, value)
        StarCursorDB.alpha = value
        currentVisualScale = StarCursorDB.scale
        UpdateVisuals()
    end)

    -- ICON HEADER (NEW)
    local iconHeader = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    iconHeader:SetPoint("TOPLEFT", alphaSlider, "BOTTOMLEFT", 0, -25)
    iconHeader:SetText("Cursor Icon")

    -- ICON DROPDOWN 
    local iconDropdown = CreateFrame("DropdownButton", "StarCursorIconDropdown", panel, "WowStyle1DropdownTemplate")
    iconDropdown:SetPoint("TOPLEFT", iconHeader, "BOTTOMLEFT", -15, -10)
    iconDropdown:SetWidth(150) 

    iconDropdown:SetupMenu(function(dropdown, rootDescription)
        for _, data in ipairs(textureList) do
            rootDescription:CreateRadio(
                data.name,
                function() return StarCursorDB.texture == data.name end,
                function()
                    StarCursorDB.texture = data.name
                    currentVisualScale = StarCursorDB.scale
                    UpdateVisuals()
                end
            )
        end
    end)

    -- TRAIL HEADER (Modernized)
    local trailHeader = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    trailHeader:SetPoint("TOPLEFT", iconDropdown, "BOTTOMLEFT", 15, -20)
    trailHeader:SetText("Trail Style")

    -- TRAIL DROPDOWN
    local trailDropdown = CreateFrame("DropdownButton", "StarCursorTrailDropdown", panel, "WowStyle1DropdownTemplate")
    trailDropdown:SetPoint("TOPLEFT", trailHeader, "BOTTOMLEFT", -15, -10)
    trailDropdown:SetWidth(150)

    trailDropdown:SetupMenu(function(dropdown, rootDescription)
        for _, data in ipairs(trailTextureList) do
            rootDescription:CreateRadio(
                data.name,
                function() return StarCursorDB.trailTexture == data.name end,
                function()
                    StarCursorDB.trailTexture = data.name
                    currentVisualScale = StarCursorDB.scale
                    UpdateVisuals()
                end
            )
        end
    end)
    
    -- Color Button
    local colorBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    colorBtn:SetSize(200, 25)
    colorBtn:SetPoint("TOPLEFT", trailDropdown, "BOTTOMLEFT", 15, -20)
    colorBtn:SetText("Change Color")
    colorBtn:SetScript("OnClick", OpenColorPicker)

    -- Reset Button
    local resetBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    resetBtn:SetSize(200, 25)
    resetBtn:SetPoint("TOPLEFT", colorBtn, "BOTTOMLEFT", 0, -30)
    resetBtn:SetText("Reset to Defaults")
    resetBtn:SetScript("OnClick", function()
        StarCursorDB.scale = defaultSettings.scale
        StarCursorDB.alpha = defaultSettings.alpha
        StarCursorDB.trail = defaultSettings.trail
        StarCursorDB.r = defaultSettings.r
        StarCursorDB.g = defaultSettings.g
        StarCursorDB.b = defaultSettings.b
        StarCursorDB.texture = defaultSettings.texture
        StarCursorDB.trailTexture = defaultSettings.trailTexture

        trailBtn:SetChecked(defaultSettings.trail)
        scaleSlider:SetValue(defaultSettings.scale)
        alphaSlider:SetValue(defaultSettings.alpha)
        
        iconDropdown:GenerateMenu()
        trailDropdown:GenerateMenu()
        
        print("|cFF00FF00StarCursor:|r Reset complete.")
        UpdateVisuals()
    end)
end

-- 8. Initialization
local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(self, event, arg1)
    if arg1 ~= addonName then return end
    
    StarCursorDB = StarCursorDB or {}
    for k, v in pairs(defaultSettings) do
        if StarCursorDB[k] == nil then StarCursorDB[k] = v end
    end
    
    InitOptions()
    UpdateVisuals()
    
    if Settings and Settings.RegisterCanvasLayoutCategory then
        optionsCategory = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
        Settings.RegisterAddOnCategory(optionsCategory)
    else
        InterfaceOptions_AddCategory(panel)
    end
    
    self:UnregisterEvent("ADDON_LOADED")
end)

-- Slash Command
SLASH_STARCURSOR1 = "/starcursor"
SlashCmdList["STARCURSOR"] = function()
    if optionsCategory and Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(optionsCategory:GetID())
    else
        InterfaceOptionsFrame_OpenToCategory(panel)
        InterfaceOptionsFrame_OpenToCategory(panel)
    end
end
