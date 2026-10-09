# This script is responsible for moving a bullet, doing damage when applicable,
# and removing the bullet if it exceeds its range
# Parameters:
#   Bullet Data: 
#     SPEED: How fast the bullet moves, in u/s
#     RANGE: How far the bullet can move from where it is born before it should
#     die
#     DAMAGE: How much damage the bullet does
#     OWNER: Whether the bullet is player owned
# Tree:
# [bullet_2d] : Area2D
extends Area2D

var travelled_distance = 0
@export var bullet_data : BulletData = BulletData.new()

# Instantiate with data
func with_parameters(p_bullet_data : BulletData):
	bullet_data = p_bullet_data
	return self

# Move and die if appropriate
func _physics_process(delta):
	position += Vector2.RIGHT.rotated(rotation) * bullet_data.speed * delta
	
	travelled_distance += bullet_data.speed * delta
	if travelled_distance > bullet_data.maxRange:
		queue_free()

# Apply damage when possible
func _on_body_entered(body: Node2D):
	# Ignore creatures on the same team (do not consume or despawn the bullet)
	if body is Creature and body.creature_data != null and body.creature_data.ownerMask == bullet_data.owner:
		return

	# Apply damage to opposing targets
	if body.has_method("take_damage") and body.get("creature_data") != null:
		if body.creature_data.ownerMask != bullet_data.owner:
			body.take_damage(bullet_data)
	
	# Only destroy the bullet when hitting opposing targets or solid world geometry
	queue_free()
