extends VBoxContainer

@onready var back_button: Button = $BackButton

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/pause_menu.tscn")
