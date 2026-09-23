extends Node

var hover_player = AudioStreamPlayer.new()
var click_player = AudioStreamPlayer.new()

func _ready() -> void:
	# Load the audio files and add the players to the background
	hover_player.stream = preload("res://assets/sfx/buttonHover.wav")
	click_player.stream = preload("res://assets/sfx/buttonClick.wav")
	add_child(hover_player)
	add_child(click_player)
	
	# Listen for any new nodes being added to the game (like when a scene loads)
	get_tree().node_added.connect(_on_node_added)
	
	# Connect buttons that are already loaded when the game first boots
	_connect_existing_buttons(get_tree().root)

func _on_node_added(node: Node) -> void:
	# BaseButton covers Button, TextureButton, etc.
	if node is BaseButton: 
		node.mouse_entered.connect(hover_player.play)
		node.pressed.connect(click_player.play)

func _connect_existing_buttons(parent_node: Node) -> void:
	if parent_node is BaseButton:
		parent_node.mouse_entered.connect(hover_player.play)
		parent_node.pressed.connect(click_player.play)
		
	for child in parent_node.get_children():
		_connect_existing_buttons(child)
