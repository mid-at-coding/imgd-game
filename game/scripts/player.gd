# This script is responsible for moving and hurting the player character
# Parameters: None
# Tree:
# [player] : CharacterBody2D
# |_ %HappyBoo : happy_boo
# |_ %HurtBox : Area2D
# |_ %HealthBar : ProgressBar
# TODO: Merge with mob.gd
extends CharacterBody2D

signal health_depleted

var health = 100.0

# Move based on input, switch animation based on velocity, and take damage
func _physics_process(delta):
	const SPEED = 600.0
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED

	move_and_slide()
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
	
	# Taking damage
	const DAMAGE_RATE = 6.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%HealthBar.value = health
		if health <= 0.0:
			health_depleted.emit()
