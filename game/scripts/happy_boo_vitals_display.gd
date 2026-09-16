## This script shows the UI given a Creature
# Parameters: None
# Tree:
# [happy_boo_vitals_display.gd] : VBoxContainer
# |_ HealthDisplay : RichTextLabel
# |_ AmmoDisplay : RichTextLabel
extends VBoxContainer

func display(creature : Creature) -> void:
	$HealthDisplay.clear()
	$HealthDisplay.add_text("HEALTH: %05.2f/%05.2f" % \
		[creature.health, creature.creature_data.maxhealth])
	$AmmoDisplay.clear()
	$AmmoDisplay.add_text("AMMO: %05d/%05d" % \
		[creature.gun.ammo, ParameterGun.get_consumption(creature.gun.gun_data)])
