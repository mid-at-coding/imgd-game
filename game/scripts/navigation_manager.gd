# Global Script
# Manager class for all scene transitions between scenes

extends Node

const level_dict : Dictionary[String, PackedScene] = {
	"level1_game":preload("res://scenes/level1_game.tscn"),
	"dungeon_saloon_game":preload("res://scenes/dungeon_saloon_game.tscn"),
	"dungeon_saloon_left_game":preload("res://scenes/dungeon_saloon_left_game.tscn"),
	"dungeon_saloon_right_game":preload("res://scenes/dungeon_saloon_right_game.tscn"),
	"npc_room_game":preload("res://scenes/npc_room_game.tscn"),
	"level2_game":preload("res://scenes/level2_game.tscn")
}
static var saved_data : Dictionary[String, Variant];

signal on_trigger_player_spawn
signal loaded

var spawn_door_tag

## Save data from all nodes that want to save their data
func _save_data(node : Node):
	if node.has_method("state_key") and node.has_method("save_state") and node.state_key() != null:
		saved_data[node.state_key()] = node.save_state()
	for child in node.get_children():
		_save_data(child)

## Load data from all nodes that want to load their data
func _load_data(node : Node):
	if node.has_method("state_key") and node.has_method("load_state") and saved_data.has(node.state_key()):
		node.load_state(saved_data[node.state_key()])
	for child in node.get_children():
		_load_data(child)

func go_to_level(level_tag, destination_tag):
	var scene_to_load = level_dict[level_tag]
		
	if scene_to_load == null:
		return
	
	# Save data
	_save_data(get_tree().root)
	spawn_door_tag = destination_tag
	get_tree().call_deferred("change_scene_to_packed", scene_to_load)

func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)

## Restore all saved state
func restore():
	_load_data(get_tree().root)
	loaded.emit()
