## This script is responsible for displaying and giving the player the option to
## pick up a diff to their character
# Parameters:
#   Type - The type of pickup
#     CREATURE: The resource is a CreatureData which will replace 
#       player.creature_data
#     GUN: The resource is a BulletData which will replace player.gun.gun_data 
#   CreateHover - Whether a hover canvas layer should be created based on
#     stats
#   Diff - The resource to apply to the player's data
# Tree:
# root 
# |_ Game
# |  |_ Player
# ...
# [pickup.gd] : Area2D
# |_ Sprite : Implements play_float(), play_pickup() 
# |_ Hover : CanvasLayer
class_name Pickup extends Area2D
@onready var sprite : Node2D = get_node("Sprite")
@onready var hover : CanvasLayer = null
@export var diff : Resource
enum PickupType { CREATURE, GUN }
@export var type : PickupType
@export var create_hover : bool = false
@onready var player : Creature = get_node("/root/Game/Player")
var label : RichTextLabel

# Play the sprite's float animation and hide the hover, then create an initial
# hover if necessary
func _ready() -> void:
	if (!create_hover):
		hover = get_node("Hover")
	if (hover == null):
		push_warning("Hover node is null, recreating")
		create_hover = true
	if (create_hover):
		# TODO: replace with custom scene for style
		hover = CanvasLayer.new()
		add_child(hover)
		label = RichTextLabel.new()
		hover.add_child(label)
	sprite.play_float()
	hover.hide()

func _compare_prop(first : float, second : float) -> String:
	const format = "%08.2f [color=%s](%+08.2f)[/color]"
	return format % [first, "green" if first > second else "red" if first < second else "grey", first - second]

# Updates the data within the hover before showing if we own it
func _update_and_show_hover() -> void:
	if (!create_hover):
		hover.show()
		return
	const gun_format = """
	Fire Rate:    %s
	Bullets:      %s
	Spread:       %s
	Bullet Speed: %s
	Damage:       %s
	%s to pick up
	"""
	const creature_format = """
	Max Health:   %s
	Speed:        %s
	%s to pick up
	"""
	if (type == PickupType.GUN):
		var curr : GunData = player.gun.gun_data
		var new : GunData = diff
		# TODO: set this dynamically
		label.size = Vector2(715, 400)
		label.clear()
		label.append_text(gun_format % \
		[_compare_prop(new.fire_rate, curr.fire_rate),
		 _compare_prop(new.bullets, curr.bullets),
		 _compare_prop(new.spread_angle, curr.spread_angle),
		 _compare_prop(new.bullet.speed, curr.bullet.speed),
		 _compare_prop(new.bullet.damage, curr.bullet.damage),
		 InputMap.action_get_events("accept_pickup")[0].as_text()])
	
	elif (type == PickupType.CREATURE):
		var curr : CreatureData = player.creature_data
		var new : CreatureData = diff
		# TODO: set this dynamically
		label.size = Vector2(715, 200)
		label.clear()
		label.append_text(creature_format % \
		[_compare_prop(new.maxhealth, curr.maxhealth),
		 _compare_prop(new.speed, curr.speed),
		 InputMap.action_get_events("accept_pickup")[0].as_text()])
	
	# Add themes
	label.theme = preload("res://themes/pickupLabel.tres")
	label.add_theme_stylebox_override("normal", preload("res://themes/pickupLabelNormal.tres"))
	
	hover.show()

# If we encounter a pickup bind while showing we should apply the diff
func _process(_delta: float) -> void:
	if (!hover.visible || !Input.is_action_pressed("accept_pickup")):
		return
	if (type == PickupType.CREATURE):
		player.creature_data = diff
	if (type == PickupType.GUN):
		player.gun.gun_data = diff
	hover.hide()
	sprite.play_pickup()
	queue_free()

# Display hover text if player is inside us
func _on_body_entered(body: Node2D) -> void:
	if body.get("creature_data").ownerMask == BulletData.OwnerClass.PLAYER:
		_update_and_show_hover()

# Hide hover text when player is not inside of us
func _on_body_exited(body: Node2D) -> void:
	if body.get("creature_data").ownerMask == BulletData.OwnerClass.PLAYER:
		hover.hide()
