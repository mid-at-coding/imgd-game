## This script is responsible for aiming and firing a gun
# Parameters:
#   GunData - The data describing the gun to shoot
#   Target - How to target
#     MOUSE: Aim towards the mouse
#     PLAYER: Aim towards the player
#     CONSTANT: Don't change aim
#   AmmoConsumption - How much ammo to consume per .shoot()
#     >= 1: Ammo decreases by AmmoConsumption * the amount of fired bullets
#     0: Ammo is not consumed
#     <= -1: Ammo decreases by |AmmoConsumption| per shot, regardless of how
#       many bullets were fired
# Tree:
# [parameter_gun] : ParameterGun
# |_ Timer : Timer
# |_ WeaponPivot
# |  |_ WeaponBasic : Sprite2D
# |_ %ShootingPoint : Mark2D
# (if target == PLAYER)
# root 
# |_ Game
# |  |_ Player

class_name ParameterGun extends Node2D
const RANGE = 1200
const BULLET_SCENE = preload("res://scenes/bullet_2d.tscn")
enum TargetMode { MOUSE, PLAYER, CONSTANT }
@export var gun_data : GunData
@export var target : TargetMode
@export var ammo = 0
var player

func _ready() -> void:
	# Acquire player if necessary
	if target == TargetMode.PLAYER:
		player = get_node("/root/Game/Player")

# Aim gun
func _get_look(_delta: float) -> Vector2:
	if target == TargetMode.MOUSE:
		return get_global_mouse_position()
	elif target == TargetMode.PLAYER:
		return player.get_global_position()
	return Vector2(0,0)

# Transform gun and shoot if appropriate
func _physics_process(delta: float) -> void:
	look_at(_get_look(delta))
	
	# If the mouse is to the left of the gun, flip vertically
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x < global_position.x:
		$WeaponPivot/WeaponBasic.flip_v = true
	else:
		$WeaponPivot/WeaponBasic.flip_v = false

# Returns how much ammo would be consumed on a shoot()
static func get_consumption(gun_data : GunData) -> int:
	var ammo_consumption = gun_data.ammo_consumption
	if (ammo_consumption == 0):
		return 0
	elif (ammo_consumption > 0):
		return ammo_consumption * gun_data.bullets
	return abs(ammo_consumption)

# Try to fire
func fire() -> void:
	# Don't fire if we're cooling down
	if !$Timer.is_stopped():
		return
	# Don't fire if we don't have ammo
	if (ammo - get_consumption(gun_data) < 0):
		return
	ammo -= get_consumption(gun_data)
	shoot()
	$Timer.set_wait_time(1.0/gun_data.fire_rate)
	$Timer.start()

# Unconditionally pawn bullets from gun
func shoot() -> void:
	for i in gun_data.bullets:
		var mag : int = (i + 1) / 2
		var dir : int = (i % 2) * 2 - 1
		var new_bullet = BULLET_SCENE \
		.instantiate() \
		.with_parameters(gun_data.bullet)
		
		new_bullet.global_position = %ShootingPoint.global_position
		
		new_bullet.global_rotation = %ShootingPoint.global_rotation + gun_data.spread_angle * mag * dir
		
		get_tree().root.add_child(new_bullet)
