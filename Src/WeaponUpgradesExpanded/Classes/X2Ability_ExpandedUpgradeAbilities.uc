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
	Templates.AddItem(LaserSight_BonusSkill());
	
	return Templates;
}

static function X2AbilityTemplate LaserSight_Prt()
{
	local X2AbilityTemplate						Template;
	local X2Effect_LaserSight                   LaserSightEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LaserSight_Prt');

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
	LaserSightEffect.CritBonus = class'X2Item_ExpandedUpgrades'.default.CRIT_UPGRADE_PRT;
	LaserSightEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(LaserSightEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate LaserSight_BonusSkill()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityCost_Ammo					AmmoCost;
	local X2Effect_ApplyDirectionalWorldDamage  WorldDamage;
	local X2AbilityCooldown						Cooldown;
	local X2Condition_UnitProperty              TargetCondition;
	local X2AbilityToHitCalc_RollStat           RollStat;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LaserSight_BonusSkill');

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_demolition";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.bLimitTargetIcons = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 4;
	Template.AbilityCooldown = Cooldown;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 2;
	Template.AbilityCosts.AddItem(AmmoCost);

	RollStat = new class'X2AbilityToHitCalc_RollStat';
	RollStat.BaseChance = 0;
	Template.AbilityToHitCalc = RollStat;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeAlive=false;
	TargetCondition.ExcludeDead=true;
	TargetCondition.ExcludeFriendlyToSource=true;
	TargetCondition.ExcludeHostileToSource=false;
	TargetCondition.TreatMindControlledSquadmateAsHostile=true;
	TargetCondition.ExcludeNoCover=true;
	TargetCondition.ExcludeNoCoverToSource=true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	WorldDamage = new class'X2Effect_ApplyDirectionalWorldDamage';
	WorldDamage.bUseWeaponDamageType = true;
	WorldDamage.bUseWeaponEnvironmentalDamage = false;
	WorldDamage.EnvironmentalDamageAmount = 30;
	WorldDamage.bApplyOnHit = true;
	WorldDamage.bApplyOnMiss = false;
	WorldDamage.bApplyToWorldOnHit = true;
	WorldDamage.bApplyToWorldOnMiss = false;
	WorldDamage.bHitAdjacentDestructibles = true;
	WorldDamage.PlusNumZTiles = 1;
	WorldDamage.bHitTargetTile = true;
	Template.AddTargetEffect(WorldDamage);

	//  visually always appear as a miss so the target unit doesn't look like it's being damaged
	Template.bOverrideVisualResult = true;
	Template.OverrideVisualResult = eHit_Miss;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	return Template;
}