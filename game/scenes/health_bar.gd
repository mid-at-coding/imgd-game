extends TextureProgressBar


func display(creature : Creature) -> void:
	$HealthDisplay.clear()
	$HealthDisplay.add_text("HEALTH: %05.2f/%05.2f" % \
		[creature.health, creature.creature_data.maxhealth])
