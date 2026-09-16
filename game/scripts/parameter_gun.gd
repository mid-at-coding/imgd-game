## This script is responsible for aiming and firing a gun
# Parameters:
#   GunData - The data describing the gun to shoot
#   Target - How to target
#     MOUSE: Aim towards the mouse
#     PLAYER: Aim towards the player
#     CONSTANT: Don't change aim
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
var player

func _ready() -> void:
	# Acquire player if necessary
	if target == TargetMode.PLAYER:
		player = get_node("/root/Game/Player")

# Aim gun
func _get_look(delta: float) -> Vector2:
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

# Try to fire
func fire() -> void:
	if $Timer.is_stopped():
		shoot()
		$Timer.set_wait_time(1.0/gun_data.fire_rate)
		$Timer.start()

# Unconditionally pawn bullets from gun
func shoot() -> void:
	for i in gun_data.bullets:
		var mag : int = (i + 1) / 2
		var sign : int = (i % 2) * 2 - 1
		var new_bullet = BULLET_SCENE \
		.instantiate() \
		.with_parameters(gun_data.bullet)
		
		new_bullet.global_position = %ShootingPoint.global_position
		
		new_bullet.global_rotation = %ShootingPoint.global_rotation + gun_data.spread_angle * mag * sign
		
		get_tree().root.add_child(new_bullet)
