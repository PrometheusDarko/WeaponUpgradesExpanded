//------------------------------------------------------------------------
//	FILE: X2Ability_ExpandedUpgradeAbilities.uc
//	AUTHOR: PrometheusDarko (No Fox Gaming)
//	PURPOSE: Adds stat modifiers and abilities for new upgrades
//
//------------------------------------------------------------------------

class X2Ability_ExpandedUpgradeAbilities extends X2Ability
	dependson (XComGameStateContext_Ability) config(UpgradesExpanded);

//********************************
//***********LASER SIGHT**********
//********************************
var config int CRIT_UPGRADE_PRT;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(LaserSight_Prt());
	
	return Templates;
}

static function X2AbilityTemplate LaserSight(int CritBonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local X2Effect_LaserSight                   LaserSightEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_hunter";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	LaserSightEffect = new class'X2Effect_LaserSight';
	LaserSightEffect.BuildPersistentEffect(1, true, false, false);
	LaserSightEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
	LaserSightEffect.CritBonus = CritBonus;
	LaserSightEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(LaserSightEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate LaserSight_Prt()
{
	return LaserSight(class'X2Item_ExpandedUpgrades'.default.CRIT_UPGRADE_PRT, 'LaserSight_Prt');
}