extends Area2D

const BULLET_SCENE = preload("res://scenes/bullet_2d.tscn")

# The spread angle in radians (15 degrees in this example)
var spread_angle: float = deg_to_rad(15.0)

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	# If the mouse is to the left of the gun, flip vertically
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x < global_position.x:
		$WeaponPivot/Pistol.flip_v = true
	else:
		$WeaponPivot/Pistol.flip_v = false
	
	# Hold down Left Mouse Button to shoot continuously based on the Timer cooldown
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and $Timer.is_stopped():
		shoot()
		$Timer.start()


func shoot() -> void:
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
