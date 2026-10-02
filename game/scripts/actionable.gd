extends Area2D

const Balloon = preload("res://addons/dialogue_manager/dialogues/balloon.tscn")


@export var dialogue_resource: DialogueResource
@export var dialogue_start = "start"

func action() -> void:
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)
#	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
