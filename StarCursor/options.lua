-- Slash command to open color picker
SLASH_COLORPICKER1 = "/starcolour"
SlashCmdList["COLORPICKER"] = function()
    local prevr, prevg, prevb, preva = StarCursor.texture:GetVertexColor()
    StarCursor.texture:Show();
    ColorPickerFrame:SetupColorPickerAndShow({
        r = StarCursorSettings.r,
        g = StarCursorSettings.g,
        b = StarCursorSettings.b,
        opacity = StarCursorSettings.alpha,
        hasOpacity = true,
        swatchFunc = function()
            local r, g, b = ColorPickerFrame:GetColorRGB()
            local a = ColorPickerFrame:GetColorAlpha()
            StarCursor.texture:SetVertexColor(r, g, b, a)
            StarCursorSettings.r, StarCursorSettings.g, StarCursorSettings.b, StarCursorSettings.alpha = r, g, b, a
        end,
        cancelFunc = function()
            StarCursor.texture:SetVertexColor(prevr, prevg, prevb, preva)
            StarCursorSettings.r, StarCursorSettings.g, StarCursorSettings.b, StarCursorSettings.alpha = prevr, prevg, prevb, preva
        end
    })
end

-- Slash command for help
SLASH_HELP1 = "/starcursor"
SlashCmdList["HELP"] = function()
    print("StarCursor:")
    print("/starcolour - Opens a color picker")
end
