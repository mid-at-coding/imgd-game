## This is a data class that describes a gun 
class_name GunData extends Resource
## How many times the gun fires per second
@export var fire_rate : int = 5
## How many bullets the gun fires per shot
@export var bullets : int = 3
## The angle between each of the shot bullets
@export var spread_angle : float = deg_to_rad(15)
## The bullets being shot
@export var bullet : BulletData = BulletData.new()
## How much ammo is spent per shot (see parameter_gun.gd)
@export var ammo_consumption : int = 0
