# This script is responsible for going to ./scenes/main_menu on click.
# Parameters: None
# Tree:
# [changelog_to_main] : Button
# TODO this script should be parameterized on the scene to go to
extends Button

# Change scene
func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
