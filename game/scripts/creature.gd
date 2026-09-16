# This class is responsible for managing a creature with stats, which involves
# - Moving
# - Taking damage and dying
# - Playing animations
#   - Idle when velocity == 0
#   - Walking when velocity > 0
#   - Hurt when hit
# Parameters:
#   Movement: Enum to select how the creature should move
#     INPUT  - Move based on input
#     FOLLOW - Move directly towards the player
#     STAND - Stand still
#   Shoot: How the creature should choose to shoot
#     NEVER - Never shoot
#     ALWAYS - Always shoot
#     MOUSE - Shoot when M1 is down
#   Speed: Maximum speed, in u/s
#   Health: Maxiumum health
#   SpritePath: The path to get the Sprite node from (see below)
#   GunPath: The path to get the ParameterGun (see below)
#   OwnerMask: Ignore damage from a given owner
# Tree:
# [creature] : Creature
# |_ Sprite : Implements play_walk, play_idle, play_hurt, and die
# |_ Gun : ParameterGun
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

enum TargetMode { INPUT, FOLLOW, STAND }
enum ShootMode { NEVER, ALWAYS, MOUSE }
@export var movement = TargetMode.FOLLOW
@export var shoot = ShootMode.NEVER
@export var speed = 200
@export var maxhealth = 3.0
@export var spriteName = "Sprite"
@export var gunName = "ParameterGun"
@export var ownerMask : BulletData.OwnerClass = BulletData.OwnerClass.PLAYER
@onready var sprite = get_node(spriteName)
@onready var gun = get_node(gunName)
@onready var health = maxhealth
var player

func _ready():
	if movement == TargetMode.FOLLOW:
		player = get_node("/root/Game/Player")
	sprite.play_idle()
	NavigationManager.on_trigger_player_spawn.connect(_on_spawn)
	
func _on_spawn(position: Vector2, direction: String):
	global_position = position

# Construct a creature with certain parameters
@warning_ignore("shadowed_variable")
func with_parameters(movement : TargetMode, speed : int, maxhealth : int) -> Creature:
	self.movement = movement
	self.speed = speed
	self.maxhealth = maxhealth
	return self

# Return the direction that the character should move towards based on TargetMode
func _get_direction_vector() -> Vector2:
	if movement == TargetMode.INPUT :
		return Input.get_vector("move_left", "move_right", "move_up", "move_down")
	elif movement == TargetMode.FOLLOW:
		return global_position.direction_to(player.global_position)
	return Vector2(0,0)

# Try to fire bullet
func _try_fire() -> void:
	if shoot == ShootMode.NEVER:
		return
	elif shoot == ShootMode.MOUSE and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		gun.fire()
	elif shoot == ShootMode.ALWAYS:
		gun.fire()

# Move, play the appropriate animation, and fire if necessary
func _physics_process(_delta: float) -> void:
	var direction = _get_direction_vector()
	if (direction.length() > 0):
		sprite.play_walk()
	else:
		sprite.play_idle()
	velocity = direction * speed
	move_and_slide()
	_try_fire()

# Take damage when hit by bullet
func take_damage(bullet: BulletData):
	sprite.play_hurt(health)
	health -= bullet.damage
	if health <= 0:
		# TODO: Maybe we should wait around before queue_free()ing? Perhaps
		# listen for a signal?
		sprite.die()
		queue_free()

# Pass signal from happy_boo so that game can read it
# XXX: this should definitely be done a different way
func _on_happy_boo_health_depleted() -> void:
	health_depleted.emit()
