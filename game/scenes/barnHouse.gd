# This script is responsible for spawning ghosts from a house in waves.
# Parameters:
#   ghost_scene: The PackedScene of the ghost enemy to spawn
#   ghosts_to_spawn: Total number of ghosts this house contains
#   spawn_interval: Time between each ghost spawn
# Tree:
# [level1_game_house] : Node2D (or Sprite2D)
# |_ SpawnTimer : Timer
extends Node2D

@export var ghost_scene: PackedScene
@export var ghosts_to_spawn: int = 4
@export var spawn_interval: float = 2.0

@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.wait_time = spawn_interval

# Starts the wave of ghosts spawning from this house
func start_spawning() -> void:
	if ghosts_to_spawn > 0:
		spawn_timer.start()

# Spawns a ghost and decrements the counter, stopping when empty
func _on_spawn_timer_timeout() -> void:
	if ghosts_to_spawn <= 0:
		spawn_timer.stop()
		return
		
	ghosts_to_spawn -= 1
	var ghost = ghost_scene.instantiate()
	
	# Add to the level so they move independently of the house
	get_tree().current_scene.add_child(ghost)
	ghost.global_position = global_position 
	
	if ghosts_to_spawn <= 0:
		spawn_timer.stop()
