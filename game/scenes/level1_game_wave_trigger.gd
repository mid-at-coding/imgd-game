# This script triggers assigned houses to start spawning when the player enters.
# Parameters:
#   connected_houses: Array of house nodes that should trigger together
# Tree:
# [level1_game_wave_trigger] : Area2D
# |_ CollisionShape2D : CollisionShape2D
extends Area2D

@export var connected_houses: Array[Node2D]

# Trigger the wave and delete the tripwire so it only happens once
func _on_body_entered(body: Node2D) -> void:
	# Check if the body is the player using the Creature class structure
	if body is Creature and body.creature_data.ownerMask == BulletData.OwnerClass.PLAYER:
		for house in connected_houses:
			if house.has_method("start_spawning"):
				house.start_spawning()
		queue_free()
