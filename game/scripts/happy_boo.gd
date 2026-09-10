# This script plays idle and walk animations
# Parameters:
#   damage_rate: How much damage to take per second per enemy
# Tree:
# [happy_boo] : Node2D
# |_ %AnimationPlayer : AnimationPlayer
# |_ %HealthBar : ProgressBar
# |_ %HurtBox : Area2D
extends Node2D

signal health_depleted
@export var damage_rate = 6.0

# Plays idle animation
func play_idle():
	%AnimationPlayer.play("idle")

# Plays walk animation
func play_walk():
	%AnimationPlayer.play("walk")

# There is no hurt animation, currently
func play_hurt(health):
	%HealthBar.value = health

# Take damage
func _physics_process(delta: float) -> void:
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs:
		get_parent().take_damage(damage_rate * overlapping_mobs.size() * delta)

# Raise death signal
func die():
	health_depleted.emit()
