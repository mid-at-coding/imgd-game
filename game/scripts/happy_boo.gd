# This script plays idle and walk animations
# Parameters:
# Tree:
# [happy_boo] : Node2D
# |_ $AnimatedSprite2D : AnimatedSprite2D
# |_ %HealthBar : ProgressBar
# |_ %VitalsDisplay : Implements .display(Creature)
# |_ %HurtBox : Area2D
# TODO adjust happyboo code to be new Player code (code that uses %AnimationPlayer are old)
extends Node2D

signal health_depleted
var _last_creature_read : float = 0.2
const _creature_read_time : float = 0.1

# Plays idle animation
func play_idle():
	$AnimatedSprite2D.play("idle")

# Plays walk animation
func play_walk():
	$AnimatedSprite2D.play("walk")

# There is no hurt animation, currently
func play_hurt(health):
	%HealthBar.value = health

# Update UI
func _creature_read():
	var creature : Creature = get_parent()
	%HealthBar.value = creature.health
	%HealthBar.max_value = creature.creature_data.maxhealth
	%VitalsDisplay.display(creature)

# Update sprite
func _physics_process(delta: float) -> void:
	_last_creature_read += delta
	if (_last_creature_read > _creature_read_time):
		_last_creature_read = 0
		_creature_read()
	var direction := Input.get_axis("move_left", "move_right")
	# Flip based on input direction
	if direction != 0:
		$AnimatedSprite2D.flip_h = direction > 0

# Raise death signal
func die():
	health_depleted.emit()
