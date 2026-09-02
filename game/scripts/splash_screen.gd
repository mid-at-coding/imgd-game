extends Control

@onready var logo: TextureRect = $Logo

func _ready() -> void:
	# Make the logo invisible to start
	logo.modulate.a = 0.0
	
	# Animate fade in, hold, and fade out
	var tween = create_tween()
	tween.tween_property(logo, "modulate:a", 1.0, 1.0) # Fade in
	tween.tween_interval(2.0)                          # Hold visible
	tween.tween_property(logo, "modulate:a", 0.0, 1.0) # Fade out
	tween.tween_callback(_go_to_menu)

func _go_to_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
