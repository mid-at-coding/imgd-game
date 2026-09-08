# This script is responsible for playing the walk and hurt animations for a
# slime
# Parameters: None
# Tree:
# [slime] : Node2D
# |_ %AnimationPlayer : AnimationPlayer
extends Node2D

# Play movement animation
func play_walk():
	%AnimationPlayer.play("walk")

# Play hurt animation, and then go back to playing movement animation
func play_hurt():
	%AnimationPlayer.play("hurt")
	%AnimationPlayer.queue("walk")
