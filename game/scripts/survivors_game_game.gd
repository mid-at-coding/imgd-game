extends Node2D


func spawn_mob1():
	%PathFollow2D.progress_ratio = randf()
	var new_mob = preload("res://scenes/mob1.tscn").instantiate()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)

func spawn_mob2():
	%PathFollow2D.progress_ratio = randf()
	var new_mob = preload("res://scenes/mob2.tscn").instantiate()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)


func _on_timer_timeout():
	spawn_mob1()
	spawn_mob2()


func _on_player_health_depleted():
	%GameOver.show()
	get_tree().paused = true
