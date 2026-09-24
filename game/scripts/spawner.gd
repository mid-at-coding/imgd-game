## This script is responsible for managing a number of creatures, and doing
## something when all of them die
# Parameters:
#   Creatures: A list of the paths of all the Creatures that this Spawner is
#     responsible for
#   Doors: Paths to all of the Doors that this Spawner is responsible for 
# Tree:
# [spawner] : Spawner
# |_ (Creatures[0..n]) : Creature
# |_ (Door[0..n]) : Door
class_name Spawner extends Node
@export var Creatures : Array[NodePath]
@export var Doors : Array[NodePath]

# Unlock the doors if all our creatures are gone
func _physics_process(delta: float) -> void:
	for creature_path in Creatures:
		var creature = get_node(creature_path)
		if creature != null:
			return
	for door_path in Doors:
		get_node(door_path).locked = false
