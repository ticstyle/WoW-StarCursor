-- Luacheck configuration for StarCursor
std = "max"

-- Globals whose fields can be read
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

-- Globals whose fields can be mutated/written to
mutated_globals = {
	"SlashCmdList",
	"ColorPickerFrame",
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
