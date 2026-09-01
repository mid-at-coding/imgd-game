extends VBoxContainer

@onready var button_start: Button = $ButtonStart
@onready var button_change: Button = $ButtonChange
@onready var button_credits: Button = $ButtonCredits

func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/survivors_game.tscn")

func _on_button_change_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/changelog.tscn")


func _on_button_credits_pressed() -> void:
	pass # Replace with function body.
