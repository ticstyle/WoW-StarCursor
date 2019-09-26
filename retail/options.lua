local L = LibStub("AceLocale-3.0"):GetLocale("StarCursor", false)

hooksecurefunc("InterfaceOptionsFrame_OpenToCategory",InterfaceOptionsFrame_OpenToCategory)

-- Blizzard options frame
        local panel = CreateFrame("Frame", "StarCursorBlizzOptions")
        panel.name = "StarCursor"
        InterfaceOptions_AddCategory(panel)
 

        local fs = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        fs:SetPoint("TOPLEFT", 10, -15)
        fs:SetPoint("BOTTOMRIGHT", panel, "TOPRIGHT", 10, -45)
        fs:SetJustifyH("LEFT")
        fs:SetJustifyV("TOP")
        fs:SetText("StarCursor")

        local button = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
        button:SetText(L['Configure'])
        button:SetWidth(128)
        button:SetPoint("TOPLEFT", 10, -48)
        button:SetScript('OnClick', function()
            
            print("StarCursor: Options are comming soon. ")
        end)

		-- Slash Handler
		SLASH_STARCURSOR1 = "/sc"
		SlashCmdList.STARCURSOR = function(msg)
	InterfaceOptionsFrame_OpenToCategory(StarCursorBlizzOptions)
end