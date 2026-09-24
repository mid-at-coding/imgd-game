## This script is responsible for spawning one or multiple waves of Creatures
## and opening a door when all of them are dead
# Parameters:
#   Spawners: A list of the spawners, in order, that must be spawned
#   Delay: How long to wait in between each wave
#   Doors: A list of the doors to open when all the waves are spawned
# Tree:
# [wave_manager] : WaveManager
# |_ (Spawners[0..n]) : Spawner
# |_ (Doors[0..n]) : Door
class_name WaveManager extends Node2D

@export var Spawners : Array[Spawner]
@export var Delay : float = 3
@export var Doors : Array[Door]
var _spawners_left = 0
var _curr = 0

func _advance() -> void:
	if _spawners_left == 1:
		_unlock();
		return
	_spawners_left -= 1
	_curr += 1
	get_tree().create_timer(Delay).timeout.connect(Spawners[_curr].spawn)

func _ready() -> void:
	Spawners[_curr].spawn()
	for spawner in Spawners:
		_spawners_left += 1
		# Avoid connecting a signal multiple times
		if (!spawner.creatures_dead.is_connected(_advance)):
			spawner.creatures_dead.connect(_advance)

# Unlock our doors
func _unlock() -> void:
	for door in Doors:
		door.locked = false
