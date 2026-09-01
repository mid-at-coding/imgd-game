extends Area2D

# Make sure to update this path to your actual bullet scene
const BULLET_SCENE = preload("res://scenes/bullet_2d.tscn")

# The spread angle in radians (15 degrees in this example)
var spread_angle: float = deg_to_rad(15.0)

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)

func _on_timer_timeout():
	# Define the rotational offsets for the 3 bullets: left, center, right
	var angles = [-spread_angle, 0.0, spread_angle]
	
	for angle in angles:
		var new_bullet = BULLET_SCENE.instantiate()
		
		# Spawn the bullet at the ShootingPoint's location 
		new_bullet.global_position = %ShootingPoint.global_position
		
		# Set rotation to the ShootingPoint's rotation plus the cone offset 
		new_bullet.global_rotation = %ShootingPoint.global_rotation + angle
		
		# Add the bullet to the main scene tree so it moves independently of the gun
		get_tree().root.add_child(new_bullet)
