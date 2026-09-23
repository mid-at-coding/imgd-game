# This script is responsible for fading in the main menu and connecting the
# main menu buttons
# Parameters: None
# Tree:
# [main_menu_button_holder]
# |_ button_start : TextureButton
# |_ button_change : TextureButton
# |_ button_credits : TextureButton
# TODO: Should this be responsible for fading in the main menu?
# TODO: Paramaterize scenes and spawn buttons?
extends VBoxContainer

@onready var button_start: TextureButton = $ButtonStart
@onready var button_change: TextureButton = $ButtonChange
@onready var button_credits: TextureButton = $ButtonCredits

# Fade in main menu
func _ready() -> void:
	# Target the root scene so both the background and buttons fade in
	var menu_root = owner if owner else self
	menu_root.modulate.a = 0.0
	
	# Fade in over 1.5 seconds
	var tween = create_tween()
	tween.tween_property(menu_root, "modulate:a", 1.0, 1.5)
	

# Stop background music and transition to game
func _on_button_start_pressed() -> void:
	Bgm.stop() 
	get_tree().change_scene_to_file("res://scenes/level1_game.tscn")

# Transition to changelog
func _on_button_change_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/changelog.tscn")

# Transition to credits
func _on_button_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
