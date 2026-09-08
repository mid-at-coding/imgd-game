# This script is responsible for moving a bullet, doing damage when applicable,
# and removing the bullet if it exceeds its range
# Parameters:
#   SPEED: How fast the bullet moves, in u/s
#   RANGE: How far the bullet can move from where it is born before it should
#   die
# Tree:
# [bullet_2d] : Area2D
extends Area2D

var travelled_distance = 0
@export var SPEED: int = 1000
@export var RANGE: int = 1200

# Move and die if appropriate
func _physics_process(delta):
	position += Vector2.RIGHT.rotated(rotation) * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()

# Apply damage when possible
func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
