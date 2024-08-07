-- Slash command to change color
SLASH_COLORCHANGE1 = "/starcolour"
SlashCmdList["COLORCHANGE"] = function(msg)
    local r, g, b = strsplit(" ", msg)
    r, g, b = tonumber(r), tonumber(g), tonumber(b)
    if r and g and b then
        local alpha = StarCursor.texture:GetAlpha()
        StarCursor.texture:SetVertexColor(r, g, b, alpha)
        StarCursorSettings.r, StarCursorSettings.g, StarCursorSettings.b = r, g, b
    end
end

-- Slash command to adjust alpha
SLASH_ALPHACHANGE1 = "/staralpha"
SlashCmdList["ALPHACHANGE"] = function(msg)
    local alpha = tonumber(msg)
    if alpha and alpha >= 0 and alpha <= 1 then
        StarCursor.texture:SetAlpha(alpha)
        StarCursorSettings.alpha = alpha
    end
end

-- Slash command for help
SLASH_HELP1 = "/starcursor"
SlashCmdList["HELP"] = function()
    print("StarCursor:")
    print("/starcolour <r> <g> <b> - Change texture color (0-1)")
    print("/starcolour 1 1 1 - For white")
    print("/staralpha <alpha> - Change texture alpha (0-1)")
    print("/staralpha 1 - For full alpha")
end
