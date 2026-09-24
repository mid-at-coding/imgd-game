## This script is responsible for managing a number of creatures, and emitting
## a signal when all of them die
# Parameters:
#   Creatures: A scene that will get instantiated under the spawner when 
#     .spawn() is called, that when all of the Creatures that are children of
#     are dead will open the given Doors
# Tree:
# [spawner] : Spawner
# |_ (Creatures) : PackedScene
class_name Spawner extends Node2D

signal creatures_dead

@export var Creatures : PackedScene
var scene : Node = null
var _left : int = 0

## Update counter and unlock doors if appropriate on Creature death
func _handle_death() -> void:
	_left -= 1;
	if _left > 0:
		return
	creatures_dead.emit()
	# Reset to be ready for next
	scene.queue_free()
	scene = null

## Spawn our creatures
func spawn() -> void:
	scene = Node2D.new()
	scene.add_child(Creatures.instantiate())
	add_child(scene)
	_left = _creatures_left(scene)

## Recursively check how many creatures exist in a tree, and connect 
## _handle_death to all of them.
func _creatures_left(node) -> int:
	var curr = 0
	for c in node.get_children():
		if c is Creature:
			c.health_depleted.connect(_handle_death)
			curr += 1
		curr += _creatures_left(c)
	return curr
