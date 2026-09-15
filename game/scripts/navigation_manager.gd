# Global Script
# Manager class for all scene transitions between scenes

extends Node

const scene_level1_game = preload("res://scenes/level1_game.tscn")
const scene_dungeon_saloon_game = preload("res://scenes/dungeon_saloon_game.tscn")

signal on_trigger_player_spawn

var spawn_door_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	
	match level_tag:
		"level1_game":
			scene_to_load = scene_level1_game
		"dungeon_saloon_game":
			scene_to_load = scene_dungeon_saloon_game
		
	if scene_to_load != null:
		spawn_door_tag = destination_tag
		get_tree().call_deferred("change_scene_to_packed", scene_to_load)



func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)
