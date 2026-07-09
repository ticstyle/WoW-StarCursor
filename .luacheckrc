-- Luacheck configuration for StarCursor
std = "max"

-- Globals that can be read, written to, and have fields mutated
globals = {
	"StarCursorDB",
	"SLASH_STARCURSOR1",
	"SlashCmdList",
	"ColorPickerFrame",
}

-- Read-only globals provided by the WoW API
read_globals = {
	"UIParent",
	"CreateFrame",
	"GetCursorPosition",
	"UIFrameFadeOut",
	"Settings",
	"InterfaceOptions_AddCategory",
	"InterfaceOptionsFrame_OpenToCategory",
	"GameFontNormalLarge",
	"GameFontNormal",
	"OptionsSliderTemplate",
	"InterfaceOptionsCheckButtonTemplate",
	"WowStyle1DropdownTemplate",
	"UIPanelButtonTemplate",
	"_G",
}

-- Ignore unused argument warnings (e.g. self in event callbacks)
ignore = {
	"212",
}
