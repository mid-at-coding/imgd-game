# This script is responsible for fading in the main menu and connecting the
# main menu buttons
# Parameters: None
# Tree:
# [main_menu_button_holder]
# |_ button_start : Button
# |_ button_change : Button
# |_ button_credits : Button
# TODO: Should this be responsible for fading in the main menu?
# TODO: Paramaterize scenes and spawn buttons?
extends VBoxContainer

@onready var button_start: Button = $ButtonStart
@onready var button_change: Button = $ButtonChange
@onready var button_credits: Button = $ButtonCredits

# Fade in main menu
func _ready() -> void:
	# Target the root scene so both the background and buttons fade in
	var menu_root = owner if owner else self
	menu_root.modulate.a = 0.0
	
	# Fade in over 1.5 seconds
	var tween = create_tween()
	tween.tween_property(menu_root, "modulate:a", 1.0, 1.5)

func _on_button_start_pressed() -> void:
	Bgm.stop() # Stops the menu track immediately
	get_tree().change_scene_to_file("res://scenes/survivors_game.tscn")

func _on_button_change_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/changelog.tscn")

func _on_button_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
