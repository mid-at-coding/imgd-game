# Currently unused, replaced by balloon

extends CanvasLayer

signal dialogue_finished

const CHAR_READ_RATE = 0.04

@onready var textbox_container = $TextboxContainer
@onready var label = $TextboxContainer/Panel/MarginContainer/HBoxContainer/Label
@onready var end_symbol = $TextboxContainer/Panel/MarginContainer/HBoxContainer/End
var current_state = State.READY
var tween : Tween

enum State {
	READY, 
	READING, 
	FINISHED
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Starting state: State.READY")
	hide_textbox()


func _process(delta: float) -> void:
	match current_state:
		State.READING:
			if(Input.is_action_just_pressed("ui_accept")):
				_finished()
				
		State.FINISHED:
			if(Input.is_action_just_pressed("ui_accept")):
				change_state(State.READY)
				hide_textbox()
				dialogue_finished.emit()
				


func hide_textbox():
	end_symbol.hide()
	label.visible_ratio = 0
	textbox_container.hide()
	
func show_textbox():
	end_symbol.show()
	textbox_container.show()
	tween = create_tween()
	tween.finished.connect(_finished)
	
func _finished():
	tween.stop()
	end_symbol.show()
	label.visible_ratio = 1
	change_state(State.FINISHED)
	
func display_text(dialogue_line : DialogueLine):
	if current_state != State.READY:
		return
	label.text = dialogue_line.text
	show_textbox() 
	change_state(State.READING)
	
	# runs to tweening animation for showing text
	tween.tween_property(label, "visible_ratio", 1, len(dialogue_line) * CHAR_READ_RATE)



func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to: to State.READY")
		State.READING:
			print("Changing state to: to State.READING")
		State.FINISHED:
			print("Changing state to: to State.FINISHED")
