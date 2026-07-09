-- Luacheck configuration for StarCursor
std = "max"

-- WoW API globals and frame templates
read_globals = {
	"UIParent",
	"CreateFrame",
	"GetCursorPosition",
	"ColorPickerFrame",
	"UIFrameFadeOut",
	"Settings",
	"InterfaceOptions_AddCategory",
	"InterfaceOptionsFrame_OpenToCategory",
	"SlashCmdList",
	"GameFontNormalLarge",
	"GameFontNormal",
	"OptionsSliderTemplate",
	"InterfaceOptionsCheckButtonTemplate",
	"WowStyle1DropdownTemplate",
	"UIPanelButtonTemplate",
	"_G",
}

-- Globals set by the addon
globals = {
	"StarCursorDB",
	"SLASH_STARCURSOR1",
}

-- Ignore unused argument warnings (e.g. self in event callbacks)
ignore = {
	"212",
}
