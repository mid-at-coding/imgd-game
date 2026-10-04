# This script is responsible for connecting pause menu buttons

extends VBoxContainer
@onready var resume_button: Button = $ResumeButton
@onready var control_button: Button = $ControlButton
@onready var menu_button: Button = $MenuButton
@onready var vol_slider: HSlider = $VolumeSlider




# Send player to designated scene

func _on_resume_button_pressed() -> void:
	# goes back to game
	pass # Replace with function body.


func _on_control_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/controls_menu.tscn")
	


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
