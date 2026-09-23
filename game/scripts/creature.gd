## This class is responsible for managing a creature with stats, which involves
## - Moving
## - Taking damage and dying
## - Playing animations
##   - Idle when velocity == 0
##   - Walking when velocity > 0
##   - Hurt when hit
## - Firing a ParameterGun
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
# |_ %Player
# ...
# TODO: Make the sprite an interface
class_name Creature extends CharacterBody2D

signal health_depleted

@export var creature_data : CreatureData = CreatureData.new()
static var hurt_tint_time : float = 0.2
static var hurt_tint : Color = Color(1.0, 0.526, 0.489, 1.0)
@onready var sprite = get_node(creature_data.spriteName)
@onready var gun : ParameterGun = get_node(creature_data.gunName)
@onready var health = creature_data.maxhealth
@onready var shoot_sound = get_node_or_null("ShootSound")
@onready var end_shoot_sound = get_node_or_null("EndShootSound")
var was_shooting : bool = false
var time_spent_shooting : float = 0.0
# Requires shooting for 0.5 seconds before playing the end sound. Adjust as needed!
var min_shoot_time_for_tail : float = 2.0
var player

func _ready():
	if creature_data.movement == CreatureData.TargetMode.FOLLOW:
		player = get_node("%Player")
	sprite.play_idle()
	NavigationManager.on_trigger_player_spawn.connect(_on_spawn)

func _on_spawn(position: Vector2, direction: String):
	if (creature_data.ownerMask != BulletData.OwnerClass.PLAYER):
		return
	global_position = position
	NavigationManager._restore_player()

# Construct a creature with certain parameters
@warning_ignore("shadowed_variable")
func with_parameters(p_creature_data : CreatureData) -> Creature:
	creature_data = p_creature_data
	return self

# Return the direction that the character should move towards based on TargetMode
func _get_direction_vector() -> Vector2:
	if creature_data.movement == CreatureData.TargetMode.INPUT :
		return Input.get_vector("move_left", "move_right", "move_up", "move_down")
	elif creature_data.movement == CreatureData.TargetMode.FOLLOW:
		return global_position.direction_to(player.global_position)
	return Vector2(0,0)

# Try to fire bullet and handle shooting audio states
func _try_fire(delta: float) -> void:
	if creature_data.shoot == CreatureData.ShootMode.NEVER:
		was_shooting = false
		time_spent_shooting = 0.0
		return
		
	var is_shooting = false
	if creature_data.shoot == CreatureData.ShootMode.MOUSE and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		is_shooting = true
	elif creature_data.shoot == CreatureData.ShootMode.ALWAYS:
		is_shooting = true
	
	if is_shooting:
		time_spent_shooting += delta
		var actually_fired = gun.fire()
		if actually_fired and shoot_sound:
			# Pitch randomization prevents the audio from sounding robotic
			shoot_sound.pitch_scale = randf_range(0.9, 1.1) 
			shoot_sound.play()
	elif was_shooting:
		if end_shoot_sound and time_spent_shooting >= min_shoot_time_for_tail:
			end_shoot_sound.play()
	was_shooting = is_shooting

# Move, play the appropriate animation, and fire if necessary
func _physics_process(_delta: float) -> void:
	var direction = _get_direction_vector()
	if (direction.length() > 0):
		sprite.play_walk()
	else:
		sprite.play_idle()
	velocity = direction * creature_data.speed
	move_and_slide()
	_try_fire(_delta)

# Take damage when hit by bullet
func take_damage(bullet: BulletData):
	
	# Apply tint
	# TODO: Should this live in sprite.play_hurt()?
	sprite.modulate = hurt_tint
	get_tree().create_timer(hurt_tint_time).timeout.connect(func():
		sprite.modulate = Color.WHITE)
	
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
