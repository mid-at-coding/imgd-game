# This script plays idle and walk animations
# Parameters: None
# Tree:
# [happy_boo] : Node2D
# |_ %AnimationPlayer : AnimationPlayer
# TODO: Just replace this with
# get_node("happy_boo").get_node("%AnimationPlayer").play(...) at callsites?
extends Node2D

signal health_depleted

# Plays idle animation
func play_idle():
	%AnimationPlayer.play("idle")

# Plays walk animation
func play_walk():
	%AnimationPlayer.play("walk")

# There is no hurt animation, currently
func play_hurt(health):
	%HealthBar.value = health

func _physics_process(delta: float) -> void:
	# Taking damage
	const DAMAGE_RATE = 6.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs:
		get_parent().take_damage(DAMAGE_RATE * overlapping_mobs.size() * delta)

# Raise death signal
func die():
	health_depleted.emit()
