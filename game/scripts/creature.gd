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
#   SpritePath: The path to get the Sprite node from (see below)
# Tree:
# [creature] : Creature
# |_ Sprite : Implements play_walk, play_idle, play_hurt, and die
# (if target == FOLLOW)
# root 
# |_ Game
# |  |_ Player
# ...
# TODO: Add attacking and damage parameter
# TODO: Parameterize sprite name
# TODO: Make the sprite an interface
class_name Creature extends CharacterBody2D

signal health_depleted

enum TargetMode { INPUT, FOLLOW }
@export var target = TargetMode.FOLLOW
@export var speed = 200
@export var maxhealth = 3.0
@export var spriteName = "Sprite"
@onready var sprite = get_node(spriteName)
@onready var health = maxhealth
var player

func _ready():
	if target == TargetMode.FOLLOW:
		player = get_node("/root/Game/Player")
	sprite.play_idle()

# Construct a creature with certain parameters
@warning_ignore("shadowed_variable")
func with_parameters(target : TargetMode, speed : int, maxhealth : int) -> Creature:
	self.target = target
	self.speed = speed
	self.maxhealth = maxhealth
	return self

# Return the direction that the character should move towards based on TargetMode
func _get_direction_vector() -> Vector2:
	if target == TargetMode.INPUT :
		return Input.get_vector("move_left", "move_right", "move_up", "move_down")
	elif target == TargetMode.FOLLOW:
		return global_position.direction_to(player.global_position)
	return Vector2(0,0)

# Move and play the appropriate animation
func _physics_process(_delta: float) -> void:
	var direction = _get_direction_vector()
	if (direction.length() > 0):
		sprite.play_walk()
	else:
		sprite.play_idle()
	velocity = direction * speed
	move_and_slide()

# Take damage when hit
func take_damage(magnitude : float):
	sprite.play_hurt(health)
	health -= magnitude
	if health <= 0:
		# TODO: Maybe we should wait around before queue_free()ing? Perhaps
		# listen for a signal?
		sprite.die()
		queue_free()

# Pass signal from happy_boo so that game can read it
# XXX: this should definitely be done a different way
func _on_happy_boo_health_depleted() -> void:
	health_depleted.emit()
