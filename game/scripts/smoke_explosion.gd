# This script is responsible for playing an animated smoke explosion
# Parameters: None
# Tree:
# [smoke_explosion] : Node2D
# |_ %Smoke : CanvasItem
# |_ %AnimationPlayer : AnimationPlayer
extends Node2D

# Play animation and die on instantiation
func _ready():
	%Smoke.material.set_shader_parameter(
		"texture_offset",
		Vector2(randfn(0.0, 1.0), randfn(0.0, 1.0)))
	%AnimationPlayer.play("explosion")
	await %AnimationPlayer.animation_finished
	queue_free()
