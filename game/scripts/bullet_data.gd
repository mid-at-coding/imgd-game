## Data class decribing a bullet
class_name BulletData extends Resource
## How fast the bullet moves, in u/s
@export var speed : int = 1000
## How far the bullet can move from its birthplace before dying
@export var maxRange : int = 1200
## How much damage the bullet deals when it hits
@export var damage : int = 1
# TODO: this class should probably be standalone
enum OwnerClass { PLAYER, ENEMY }
## What owns the bullet
@export var owner : OwnerClass = OwnerClass.PLAYER

## Create a bullet
func _init(p_speed : int = 1000, p_range : int = 1200, p_damage : int = 1, p_owner : OwnerClass = OwnerClass.PLAYER):
	speed = p_speed
	maxRange = p_range
	damage = p_damage
	owner = p_owner
