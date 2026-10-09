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
# |_ %Player

class_name ParameterGun extends Node2D
const RANGE = 1200
enum TargetMode { MOUSE, PLAYER, CONSTANT }
@export var gun_data : GunData
@export var target : TargetMode
@export var ammo = 0
var player

func _ready() -> void:
	# Acquire player if necessary
	if target == TargetMode.PLAYER:
		player = get_tree().current_scene.get_node("%Player")
		# Stagger initial firing so ghosts don't all blast on spawn frame
		if gun_data and gun_data.fire_rate > 0:
			var base_delay: float = 1.0 / float(gun_data.fire_rate)
			$Timer.start(randf_range(0.1, base_delay))

# Aim gun
func _get_look(_delta: float) -> Vector2:
	if target == TargetMode.MOUSE:
		return get_global_mouse_position()
	elif target == TargetMode.PLAYER and NavigationManager.player_alive:
		return player.get_global_position()
	return Vector2(0,0)

# Transform gun and shoot if appropriate
func _physics_process(delta: float) -> void:
	look_at(_get_look(delta))
	
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
func fire() -> bool:
	if !$Timer.is_stopped():
		return false
	if (ammo - get_consumption(gun_data) < 0):
		return false
		
	ammo -= get_consumption(gun_data)
	shoot()
	
	var base_delay: float = 1.0 / float(gun_data.fire_rate)
	
	# Only apply timing jitter to enemy guns (TargetMode.PLAYER)
	if target == TargetMode.PLAYER and gun_data.fire_rate_variance > 0.0:
		var jitter: float = base_delay * gun_data.fire_rate_variance
		var randomized_cooldown: float = randf_range(base_delay - jitter, base_delay + jitter)
		$Timer.set_wait_time(max(0.05, randomized_cooldown))
	else:
		# Player gun always maintains strict, fixed timing
		$Timer.set_wait_time(base_delay)
		
	$Timer.start()
	return true
	

# Unconditionally spawn bullets from gun
func shoot() -> void:
	for i in gun_data.bullets:
		var mag : int = (i + 1) / 2
		var dir : int = (i % 2) * 2 - 1
		var new_bullet = gun_data.bullet_scene \
		.instantiate() \
		.with_parameters(gun_data.bullet)
		
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation + gun_data.spread_angle * mag * dir
		
		get_tree().root.add_child(new_bullet)
