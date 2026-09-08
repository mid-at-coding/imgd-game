# This script plays idle and walk animations
# Parameters: None
# Tree:
# [happy_boo] : Node2D
# |_ %AnimationPlayer : AnimationPlayer
# TODO: Just replace this with
# get_node("happy_boo").get_node("%AnimationPlayer").play(...) at callsites?
extends Node2D

# Plays idle animation
func play_idle_animation():
	%AnimationPlayer.play("idle")

# Plays walk animation
func play_walk_animation():
	%AnimationPlayer.play("walk")
