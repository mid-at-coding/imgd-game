# This script is responsible for moving and damaging a mob
# Parameters: None
# Tree:
# root
# |_ Game
# |  |_ Player : Node2D
# ...
# |_ [mob1] : CharacterBody2D
#    |_ %Slime : slime
# TODO: Parameterize speed, health, i.e. stats
# TODO: Parameterize mob
# TODO: Should the chase behaviour live here?
extends CharacterBody2D

var speed = randf_range(200, 300)
var health = 3

@onready var player = get_node("/root/Game/Player")

# Play initial animation
func _ready():
	%Slime.play_walk()

# Move towards player
func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()


func take_damage():
	%Slime.play_hurt()
	health -= 1

	if health == 0:
		var smoke_scene = preload("res://scenes/smoke_explosion.tscn")
		var smoke = smoke_scene.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		queue_free()
