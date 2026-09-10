# This script is responsible for spawning mobs periodically and ending the game
# on player death
# Parameters: None
# Tree:
# [survivors_game_game] : Node2D
# |_ ... : Path2D
# |  |_ %PathFollow2D : Path2D
# |_ %GameOver : CanvasLayer
extends Node2D

# Creates a mob
func spawn_mob():
	%PathFollow2D.progress_ratio = randf()
	var new_mob = preload("res://scenes/mob.tscn").instantiate()
	new_mob.global_position = %PathFollow2D.global_position
	new_mob.speed = randf_range(200,300)
	new_mob.health = randi_range(1, 5)
	add_child(new_mob)

func _on_timer_timeout():
	spawn_mob()

func _on_player_health_depleted():
	%GameOver.show()
	get_tree().paused = true
