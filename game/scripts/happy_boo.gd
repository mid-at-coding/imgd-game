# This script plays idle and walk animations
# Parameters:
#   damage_rate: How much damage to take per second per enemy
# Tree:
# [happy_boo] : Node2D
# |_ %AnimationPlayer : AnimationPlayer
# |_ %HealthBar : ProgressBar
# |_ %HurtBox : Area2D
# TODO adjust happyboo code to be new Player code (code that uses %AnimationPlayer are old)
extends Node2D

signal health_depleted
@export var damage_rate = 6.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Plays idle animation
func play_idle():
	animated_sprite_2d.play("idle")
	%AnimationPlayer.play("idle")


# Plays walk animation
func play_walk():
	animated_sprite_2d.play("walk")
	%AnimationPlayer.play("walk")

# There is no hurt animation, currently
func play_hurt(health):
	%HealthBar.value = health

# Update sprite
func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	# Flip based on input direction
	if direction != 0:
		animated_sprite_2d.flip_h = direction > 0

# Raise death signal
func die():
	health_depleted.emit()
