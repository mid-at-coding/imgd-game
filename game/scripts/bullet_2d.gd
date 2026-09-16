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
	if travelled_distance > bullet_data.range:
		queue_free()

# Apply damage when possible
func _on_body_entered(body):
	if body.get("ownerMask") == bullet_data.owner:
		return
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage(bullet_data)
