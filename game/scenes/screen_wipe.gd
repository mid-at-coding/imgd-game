# This script is responsible for an expanding ring that acts as a screen wipe.
# Parameters:
# expansion_time: Time in seconds for the ring to reach max size
# max_scale: The maximum scale multiplier for the ring
# Tree:
# [screen_wipe] : Area2D
# |_ CollisionShape2D : CollisionShape2D
extends Area2D

@export var expansion_time : float = 1.5
@export var max_scale : float = 50.0

var wipe_payload : BulletData

# Initialize damage payload and start expansion animation
func _ready() -> void:
	wipe_payload = BulletData.new(0, 0, 9999, BulletData.OwnerClass.PLAYER)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * max_scale, expansion_time)
	tween.tween_callback(queue_free)

# Apply damage to valid enemy creatures that enter the ring
func _on_body_entered(body: Node2D) -> void:
	# Debug print so we can see EXACTLY what the ring is touching
	print("Screen wipe touched: ", body.name) 

	# Check if it has creature data (this matches your bullet_2d.gd logic!)
	if body.get("creature_data") == null:
		return
		
	# Prevent friendly fire
	if body.get("creature_data").ownerMask == wipe_payload.owner:
		return
		
	# Deal the damage
	if body.has_method("take_damage"):
		body.take_damage(wipe_payload)
