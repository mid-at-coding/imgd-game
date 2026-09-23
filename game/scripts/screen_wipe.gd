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
@onready var wipe_sound = $WipeSound

# Initialize damage payload, play sound, and start expansion animation
func _ready() -> void:
	wipe_sound.play()
	wipe_payload = BulletData.new(0, 0, 9999, BulletData.OwnerClass.PLAYER)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * max_scale, expansion_time)
	# Call our new function instead of deleting the node immediately
	tween.tween_callback(_on_expansion_finished)

func _on_expansion_finished() -> void:
	# Hide the ring and stop it from hitting enemies
	hide()
	set_deferred("monitoring", false)
	
	# Keep the node alive until the audio finishes, then destroy it
	if wipe_sound.playing:
		await wipe_sound.finished
	queue_free()

# Apply damage to valid enemy creatures that enter the ring
func _on_body_entered(body: Node2D) -> void:
	print("Screen wipe touched: ", body.name) 

	if body.get("creature_data") == null:
		return
		
	if body.get("creature_data").ownerMask == wipe_payload.owner:
		return
		
	if body.has_method("take_damage"):
		body.take_damage(wipe_payload)
