// Creates and handles the settings page if MCM is installed

class WUE_MCMListener extends UIScreenListener config(WeaponUpgradesExpanded);

`include(WeaponUpgradesExpanded/Src/ModConfigMenuAPI/MCM_API_Includes.uci)
`include(WeaponUpgradesExpanded/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)

var config int ConfigVersion;

var config int CRIT_UPGRADE_PRT;
var config int AIM_UPGRADE_PRT;
var config int AIM_UPGRADE_NOCOVER_PRT;
var config int CLIP_SIZE_PRT;
var config int FREE_FIRE_PRT;
var config int FREE_RELOADS_PRT;
var config WeaponDamageValue MISS_DAMAGE_PRT;
var config int FREE_KILL_PRT;
var config int MARK_TARGET_LOCAL_COOLDOWN;
var config int HEADSHOT_COOLDOWN;

var array<string> DropdownValues;

var array<MCM_API_Dropdown> Dropdowns;

var localized string ModName, GroupName, RestartLabelText;

var localized string CritDropdownName, CritDropdownDesc;
var localized string AimDropdownName, AimDropdownDesc;
var localized string AimNoCoverDropdownName, AimNoCoverDropdownDesc;
var localized string ClipSizeDropdownName, ClipSizeDropdownDesc;
var localized string FreeFireDropdownName, FreeFireDropdownDesc;
var localized string FreeReloadsDropdownName, FreeReloadsDropdownDesc;
var localized string MissDamageDropdownName, MissDamageDropdownDesc;
var localized string FreeKillDropdownName, FreeKillDropdownDesc;
var localized string MarkTargetDropdownName, MarkTargetDropdownDesc;
var localized string HeadshotDropdownName, HeadshotDropdownDesc;

event OnInit(UIScreen Screen)
{
	`MCM_API_Register(Screen, ClientModCallback);
}

simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
	local array<string> DropdownOptionsLong;
	local array<string> DropdownOptionsShort;
	local int i;

	local MCM_API_SettingsPage Page;
	local MCM_API_SettingsGroup Group;

	LoadSavedSettings();

	Page = ConfigAPI.NewSettingsPage(ModName);
	Page.SetPageTitle(ModName);
	Page.SetSaveHandler(SaveButtonClicked);
	Page.SetCancelHandler(RevertButtonClicked);
	Page.EnableResetButton(ResetButtonClicked);
	
	Group = Page.AddGroup('WUEGroup', GroupName);

	Group.AddLabel('WUELabel', RestartLabelText, RestartLabelText);

	for (i = 0; i <= 100; i++)
		DropdownOptionsLong.AddItem(string(i));

	for (i = 0; i <= 10; i++)
		DropdownOptionsShort.AddItem(string(i));

	Dropdowns[0] = Group.AddDropdown('WUECritDropdown', CritDropdownName, CritDropdownDesc, DropdownOptionsLong, DropdownValues[0], CritSaveHandler);
	Dropdowns[1] = Group.AddDropdown('WUEAimDropdown', AimDropdownName, AimDropdownDesc, DropdownOptionsLong, DropdownValues[1], AimSaveHandler);
	Dropdowns[2] = Group.AddDropdown('WUEAimNoCoverDropdown', AimNoCoverDropdownName, AimNoCoverDropdownDesc, DropdownOptionsLong, DropdownValues[2], AimNoCoverSaveHandler);
	Dropdowns[3] = Group.AddDropdown('WUEClipSizeDropdown', ClipSizeDropdownName, ClipSizeDropdownDesc, DropdownOptionsShort, DropdownValues[3], ClipSizeSaveHandler);
	Dropdowns[4] = Group.AddDropdown('WUEFreeFireDropdown', FreeFireDropdownName, FreeFireDropdownDesc, DropdownOptionsLong, DropdownValues[4], FreeFireSaveHandler);
	Dropdowns[5] = Group.AddDropdown('WUEFreeReloadsDropdown', FreeReloadsDropdownName, FreeReloadsDropdownDesc, DropdownOptionsShort, DropdownValues[5], FreeReloadsSaveHandler);
	Dropdowns[6] = Group.AddDropdown('WUEMissDamageDropdown', MissDamageDropdownName, MissDamageDropdownDesc, DropdownOptionsShort, DropdownValues[6], MissDamageSaveHandler);
	Dropdowns[7] = Group.AddDropdown('WUEFreeKillDropdown', FreeKillDropdownName, FreeKillDropdownDesc, DropdownOptionsLong, DropdownValues[7], FreeKillSaveHandler);
	Dropdowns[8] = Group.AddDropdown('WUEMarkTargetDropdown', MarkTargetDropdownName, MarkTargetDropdownDesc, DropdownOptionsShort, DropdownValues[8], MarkTargetSaveHandler);
	Dropdowns[9] = Group.AddDropdown('WUEHeadshotDropdown', HeadshotDropdownName, HeadshotDropdownDesc, DropdownOptionsShort, DropdownValues[9], HeadshotSaveHandler);

	Page.ShowSettings();
}

`MCM_CH_VersionChecker(class'WUE_Defaults'.default.ConfigVersion, ConfigVersion)

simulated function LoadSavedSettings()
{
	DropdownValues.Length = 0;

	LoadUserConfig();

	DropdownValues.AddItem(string(CRIT_UPGRADE_PRT));
	DropdownValues.AddItem(string(AIM_UPGRADE_PRT));
	DropdownValues.AddItem(string(AIM_UPGRADE_NOCOVER_PRT));
	DropdownValues.AddItem(string(CLIP_SIZE_PRT));
	DropdownValues.AddItem(string(FREE_FIRE_PRT));
	DropdownValues.AddItem(string(FREE_RELOADS_PRT));
	DropdownValues.AddItem(string(MISS_DAMAGE_PRT.Damage));
	DropdownValues.AddItem(string(FREE_KILL_PRT));
	DropdownValues.AddItem(string(MARK_TARGET_LOCAL_COOLDOWN));
	DropdownValues.AddItem(string(HEADSHOT_COOLDOWN));
}

`MCM_API_BasicDropdownSaveHandler(CritSaveHandler, DropdownValues[0])
`MCM_API_BasicDropdownSaveHandler(AimSaveHandler, DropdownValues[1])
`MCM_API_BasicDropdownSaveHandler(AimNoCoverSaveHandler, DropdownValues[2])
`MCM_API_BasicDropdownSaveHandler(ClipSizeSaveHandler, DropdownValues[3])
`MCM_API_BasicDropdownSaveHandler(FreeFireSaveHandler, DropdownValues[4])
`MCM_API_BasicDropdownSaveHandler(FreeReloadsSaveHandler, DropdownValues[5])
`MCM_API_BasicDropdownSaveHandler(MissDamageSaveHandler, DropdownValues[6])
`MCM_API_BasicDropdownSaveHandler(FreeKillSaveHandler, DropdownValues[7])
`MCM_API_BasicDropdownSaveHandler(MarkTargetSaveHandler, DropdownValues[8])
`MCM_API_BasicDropdownSaveHandler(HeadshotSaveHandler, DropdownValues[9])

simulated function SaveButtonClicked(MCM_API_SettingsPage Page)
{
	CRIT_UPGRADE_PRT = int(DropdownValues[0]);
	AIM_UPGRADE_PRT = int(DropdownValues[1]);
	AIM_UPGRADE_NOCOVER_PRT = int(DropdownValues[2]);
	CLIP_SIZE_PRT = int(DropdownValues[3]);
	FREE_FIRE_PRT = int(DropdownValues[4]);
	FREE_RELOADS_PRT = int(DropdownValues[5]);
	MISS_DAMAGE_PRT.Damage = int(DropdownValues[6]);
	FREE_KILL_PRT = int(DropdownValues[7]);
	MARK_TARGET_LOCAL_COOLDOWN = int(DropdownValues[8]);
	HEADSHOT_COOLDOWN = int(DropdownValues[9]);

	ConfigVersion = `MCM_CH_GetCompositeVersion();
	SaveConfig();

	// Allow proper garbage collection of UI elements
	Dropdowns.Length = 0;
}

simulated function ResetButtonClicked(MCM_API_SettingsPage Page)
{
	Dropdowns[0].SetValue(string(class'WUE_Defaults'.default.CRIT_UPGRADE_PRT), true);
	Dropdowns[1].SetValue(string(class'WUE_Defaults'.default.AIM_UPGRADE_PRT), true);
	Dropdowns[2].SetValue(string(class'WUE_Defaults'.default.AIM_UPGRADE_NOCOVER_PRT), true);
	Dropdowns[3].SetValue(string(class'WUE_Defaults'.default.CLIP_SIZE_PRT), true);
	Dropdowns[4].SetValue(string(class'WUE_Defaults'.default.FREE_FIRE_PRT), true);
	Dropdowns[5].SetValue(string(class'WUE_Defaults'.default.FREE_RELOADS_PRT), true);
	Dropdowns[6].SetValue(string(class'WUE_Defaults'.default.MISS_DAMAGE_PRT.Damage), true);
	Dropdowns[7].SetValue(string(class'WUE_Defaults'.default.FREE_KILL_PRT), true);
	Dropdowns[8].SetValue(string(class'WUE_Defaults'.default.MARK_TARGET_LOCAL_COOLDOWN), true);
	Dropdowns[9].SetValue(string(class'WUE_Defaults'.default.HEADSHOT_COOLDOWN), true);
}

simulated function RevertButtonClicked(MCM_API_SettingsPage Page)
{
	// Allow proper garbage collection of UI elements
	Dropdowns.Length = 0;
}

static function LoadUserConfig()
{
	local int UserConfigVersion, DefaultConfigVersion;

	UserConfigVersion = default.ConfigVersion;
	DefaultConfigVersion = class'WUE_Defaults'.default.ConfigVersion;

	if (UserConfigVersion < DefaultConfigVersion && !UpdateUserConfigValues(UserConfigVersion))
	{
		return;
	}

	StaticSaveConfig();
}

static function bool UpdateUserConfigValues(out int UserConfigVersion)
{
	switch (UserConfigVersion)
	{
		case 0:
			default.ConfigVersion = 1;

			default.CRIT_UPGRADE_PRT = class'WUE_Defaults'.default.CRIT_UPGRADE_PRT;
			default.AIM_UPGRADE_PRT = class'WUE_Defaults'.default.AIM_UPGRADE_PRT;
			default.AIM_UPGRADE_NOCOVER_PRT = class'WUE_Defaults'.default.AIM_UPGRADE_NOCOVER_PRT;
			default.CLIP_SIZE_PRT = class'WUE_Defaults'.default.CLIP_SIZE_PRT;
			default.FREE_FIRE_PRT = class'WUE_Defaults'.default.FREE_FIRE_PRT;
			default.FREE_RELOADS_PRT = class'WUE_Defaults'.default.FREE_RELOADS_PRT;
			default.MISS_DAMAGE_PRT = class'WUE_Defaults'.default.MISS_DAMAGE_PRT;
			default.FREE_KILL_PRT = class'WUE_Defaults'.default.FREE_KILL_PRT;
			default.MARK_TARGET_LOCAL_COOLDOWN = class'WUE_Defaults'.default.MARK_TARGET_LOCAL_COOLDOWN;
			default.HEADSHOT_COOLDOWN = class'WUE_Defaults'.default.HEADSHOT_COOLDOWN;
			break;

		default:
			`REDSCREEN("Unknown user config version" @ string(UserConfigVersion) @ "cannot be updated", true, 'WeaponUpgradesExpanded');
			`LOG("Unknown user config version " @ string(UserConfigVersion) @ "cannot be updated", true, 'WeaponUpgradesExpanded');
			return false;
	}

	`LOG("Updated user config version" @ string(UserConfigVersion) @ "to version" @ string(default.ConfigVersion), true, 'WeaponUpgradesExpanded');

	UserConfigVersion = default.ConfigVersion;

	return true;
}

defaultproperties
{
	ScreenClass = class'MCM_OptionsScreen'
}