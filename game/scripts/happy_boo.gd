# This script plays idle and walk animations
# Parameters:
# Tree:
# [happy_boo] : Node2D
# |_ $AnimatedSprite2D : AnimatedSprite2D
# |_ DashTimer : ProgressBar
# |_ %HealthBar : ProgressBar
# |_ %VitalsDisplay : Implements .display(Creature)
# |_ %HurtBox : Area2D
# TODO adjust happyboo code to be new Player code (code that uses %AnimationPlayer are old)
extends Node2D
const SCREEN_WIPE_SCENE = preload("res://scenes/screen_wipe.tscn")
var wipe_charges : int = 3
var last_dash : float = 10
const dash_time : float = 2
@onready var actionable_finder: Area2D = $Direction/ActionableFinder

signal health_depleted

# Plays idle animation
func play_idle():
	$AnimatedSprite2D.play("idle")

func state_key():
	return "happy_boo"

func save_state():
	return {"wipe_charges":wipe_charges}

func load_state(dict):
	wipe_charges = dict.wipe_charges

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
	%DashTimer.visible = last_dash - 1 < dash_time 
	%DashTimer.value = last_dash / dash_time

# Update sprite
func _physics_process(_delta: float) -> void:
	_creature_read()
	var direction := Input.get_axis("move_left", "move_right")
	# Flip based on input direction
	if direction != 0:
		$AnimatedSprite2D.flip_h = direction > 0

func apply_impulse(vel : Vector2, delta : float):
	if (last_dash <= dash_time * 10):
		last_dash += delta
	var mul = 100 * max(0, 1 - pow(5 * last_dash - 0.7, 4))
	return vel * mul * delta

# Fire screen wipe if creature is player-controlled and has charges
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("use_wipe") and wipe_charges > 0:
		wipe_charges -= 1
		var wipe = SCREEN_WIPE_SCENE.instantiate()
		wipe.global_position = global_position
		get_tree().root.add_child(wipe)
	if event.is_action_pressed("dash") and last_dash > dash_time:
		last_dash = 0
		
func _unhandled_input(event: InputEvent) -> void:
	# plays dialogue if player near interactable object
	if Input.is_action_just_pressed("accept_pickup"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return

# Raise death signal
func die():
	health_depleted.emit()
