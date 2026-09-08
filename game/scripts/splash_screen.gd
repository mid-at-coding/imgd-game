# This script is responsible for showing the initial splash screen and loading
# the main menu
# Parameters: None
# Tree:
# [splash_screen]
# |_ Logo : TextureRect
extends Control

@onready var logo: TextureRect = $Logo

# Fade in, fade out, and go to main menu
func _ready() -> void:
	# Make the logo invisible to start
	logo.modulate.a = 0.0
	
	# Animate fade in, hold, and fade out
	var tween = create_tween()
	tween.tween_property(logo, "modulate:a", 1.0, 1.0) # Fade in
	tween.tween_interval(2.0)                          # Hold visible
	tween.tween_property(logo, "modulate:a", 0.0, 1.0) # Fade out
	tween.tween_callback(
		func (): get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	)
