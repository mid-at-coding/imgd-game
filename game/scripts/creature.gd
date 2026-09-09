# This class is responsible for managing a creature with stats, which involves
# - Moving
# - Taking damage and dying
# - Playing animations
#   - Idle when velocity == 0
#   - Walking when velocity > 0
#   - Hurt when hit
# Parameters:
#   Target: Enum to select how the creature should move
#     INPUT  - Move based on input
#     FOLLOW - Move directly towards the player
#   Speed: Maximum speed, in u/s
#   Health: Maxiumum health
# Tree:
# [creature] : Creature
# |_ Sprite : Implements play_walk, play_idle, play_hurt, and die
# (if target == FOLLOW)
# root 
# |_ Game
# |  |_ Player
# ...
# TODO: Add attacking and damage parameter
# TODO: Parameterize hurtbox and sprite name
class_name Creature extends CharacterBody2D

enum TargetMode { INPUT, FOLLOW }
@export var target : TargetMode
@export var speed = 200
@export var health = 3
#@onready var hurtbox = get_node("Hurtbox")
@onready var sprite = get_node("Sprite")
@onready var player = get_node("/root/Game/Player")

# Construct a creature with certain parameters
func with_parameters(target : TargetMode, speed : int, health : int) -> Creature:
	self.target = target
	self.speed = speed
	self.health = health
	return self

# Return the direction that the character should move towards based on TargetMode
func _get_direction_vector() -> Vector2:
	if target == TargetMode.INPUT :
		return Input.get_vector("move_left", "move_right", "move_up", "move_down")
	elif target == TargetMode.FOLLOW:
		return global_position.direction_to(player.global_position)
	return Vector2(0,0)

# Play the creature's idle animation initially
func _ready() -> void:
	sprite.play_idle()

# Move and play the appropriate animation
func _physics_process(delta: float) -> void:
	var direction = _get_direction_vector()
	if (direction.length() > 0):
		sprite.play_walk()
	else:
		sprite.play_idle()
	velocity = direction * speed
	move_and_slide()

# Take damage when hit
func take_damage():
	sprite.play_hurt()
	health -= 1
	if health == 0:
		# TODO: Maybe we should wait around before queue_free()ing? Perhaps
		# listen for a signal?
		sprite.die()
		queue_free()
