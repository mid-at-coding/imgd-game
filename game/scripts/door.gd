# This script is responsible for scene transitions 
# Only allows nodes of class Creature to enter
# entering the designated area will transfer the Creature to the designated location
# Parameters:
# destination_level_tag -> the name of the scene to jump to
# destination_door_tag -> the name of the door node to jump to, without "Door_"

extends Area2D

class_name Door

@export var destination_level_tag: String
@export var destination_door_tag: String
@export var spawn_direction = "up"

@onready var spawn = $Spawn


func _on_body_entered(body: Node2D) -> void:
	if body is Creature:
		NavigationManager.go_to_level(destination_level_tag, destination_door_tag)
