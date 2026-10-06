## This script shows the UI given a Creature
# Parameters: None
# Tree:
# [happy_boo_vitals_display.gd] : VBoxContainer
# |_ HealthDisplay : RichTextLabel
# |_ AmmoDisplay : RichTextLabel
# |_ ChargeDisplay : RichTextLabel
extends VBoxContainer
@onready var screenwipe: Sprite2D = $Screenwipe
@onready var screenwipe_2: Sprite2D = $Screenwipe2
@onready var screenwipe_3: Sprite2D = $Screenwipe3

func display(creature : Creature) -> void:
	$HealthDisplay.clear()
	$HealthDisplay.add_text("HEALTH: %05.2f/%05.2f" % \
		[creature.health, creature.creature_data.maxhealth])
	$AmmoDisplay.clear()
	$AmmoDisplay.add_text("AMMO: %05d/%05d" % \
		[creature.gun.ammo, ParameterGun.get_consumption(creature.gun.gun_data)])
	$ChargeDisplay.clear()
	$ChargeDisplay.add_text("WIPES: %01d/3" % [creature.sprite.wipe_charges])
	_display_charges(creature)
	
	
func _display_charges(creature : Creature) -> void:
	if creature.sprite.wipe_charges == 3:
		screenwipe.show()
		screenwipe_2.show()
		screenwipe_3.show()
	elif creature.sprite.wipe_charges == 2:
		screenwipe_3.hide()
	elif creature.sprite.wipe_charges == 1:
		screenwipe_2.hide()
	else:
		screenwipe.hide()
