extends VBoxContainer

@onready var start_label: Label = $StartLabel
@onready var options_label: Label = $OptionsLabel
@onready var exit_label: Label = $ExitLabel
@onready var SELECTED := LabelSettings.new()
@onready var NOT_SELECTED := LabelSettings.new()
@onready var SELECTED_RECT := StyleBoxFlat.new()
@onready var error: AudioStreamPlayer = $error
@onready var tick: AudioStreamPlayer = $tick


enum STATE {
	START,
	OPTIONS,
	EXIT,
}


var current_state := 0
var states := [STATE.START, STATE.OPTIONS, STATE.EXIT]


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	SELECTED.font_color = Color.BLACK
	SELECTED.font = preload("res://assets/font/CP437.ttf")
	NOT_SELECTED.font_color = Color.WHITE
	NOT_SELECTED.font = SELECTED.font
	
	SELECTED_RECT.expand_margin_left = 10
	SELECTED_RECT.expand_margin_right = 10
	update_labels(states[current_state])


func _input(event: InputEvent) -> void:
	var states := [STATE.START, STATE.OPTIONS, STATE.EXIT]
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_DOWN:
				if current_state != len(states) - 1:
					tick.play()
					current_state = (current_state + 1) % 3
			KEY_UP:
				if current_state != 0:
					tick.play()
					current_state = (current_state - 1 + len(states)) % 3
			KEY_ENTER:
				handle_button(states[current_state])
				
	update_labels(states[current_state])


func handle_button(state: STATE):
	match state:
		STATE.START:
			get_tree().change_scene_to_file("res://ui/intro.tscn")
		STATE.OPTIONS:
			$NaoImplementado.visible = true
			error.play()
			print("não implementado")
		STATE.EXIT:
			get_tree().quit()


func update_labels(state: STATE):
	start_label.label_settings = NOT_SELECTED
	options_label.label_settings = NOT_SELECTED
	exit_label.label_settings = NOT_SELECTED
	start_label.remove_theme_stylebox_override("normal")
	options_label.remove_theme_stylebox_override("normal")
	exit_label.remove_theme_stylebox_override("normal")
	match state:
		STATE.START:
			start_label.label_settings = SELECTED
			start_label.add_theme_stylebox_override("normal", SELECTED_RECT)
		STATE.OPTIONS:
			options_label.label_settings = SELECTED
			options_label.add_theme_stylebox_override("normal", SELECTED_RECT)
		STATE.EXIT:
			exit_label.label_settings = SELECTED
			exit_label.add_theme_stylebox_override("normal", SELECTED_RECT)
