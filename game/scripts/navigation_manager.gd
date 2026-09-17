# Global Script
# Manager class for all scene transitions between scenes

extends Node

const scene_level1_game = preload("res://scenes/level1_game.tscn")
const scene_dungeon_saloon_game = preload("res://scenes/dungeon_saloon_game.tscn")
static var player_data
static var player_gun
static var player_health
static var player_ammo
static var player_charges : int = 3

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
		# Save player data
		var player : Creature = get_node("/root/Game").get_node("%Player")
		player_data = player.creature_data
		player_gun = player.gun.gun_data
		player_health = player.health
		player_ammo = player.gun.ammo
		player_charges = player.wipe_charges
		spawn_door_tag = destination_tag
		get_tree().call_deferred("change_scene_to_packed", scene_to_load)

func _restore_player():
	var player : Creature = get_node("/root/Game").get_node("%Player")
	player.creature_data = player_data
	player.gun.gun_data = player_gun
	player.health = player_health
	player.gun.ammo = player_ammo
	player.wipe_charges = player_charges

func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)
