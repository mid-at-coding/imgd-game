# This script is responsible for playing the walk and hurt animations for a
# slime
# Parameters: None
# Tree:
# [slime] : Node2D
# |_ %AnimationPlayer : AnimationPlayer
extends Node2D

# Play movement animation
func play_walk():
	if %AnimationPlayer.current_animation == "hurt":
		%AnimationPlayer.queue("walk")
	else:
		%AnimationPlayer.play("walk")

# Play hurt animation, and then go back to playing movement animation
func play_hurt(_health):
	%AnimationPlayer.play("hurt")
	%AnimationPlayer.queue("walk")

func play_idle():
	play_walk()

func die():
	var smoke_scene = preload("res://scenes/smoke_explosion.tscn")
	var smoke = smoke_scene.instantiate()
	get_parent().get_parent().add_child(smoke)
	smoke.global_position = global_position
	queue_free()
