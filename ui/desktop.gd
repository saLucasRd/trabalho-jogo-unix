extends Control


const WINDOW = preload("res://ui/fake_window.tscn")
const TERMINAL = preload("res://ui/terminal.tscn")
const MANUAL = preload("res://ui/manual.tscn")
const LEVEL = preload("res://ui/level.tscn")

@onready var desktop_area: Control = $DesktopArea
@onready var datetime: Label = $HBoxContainer/Datetime
@onready var tutorial_label: Label = $TutorialLabel

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	datetime.text = Time.get_datetime_string_from_system(false, true)


func instatentiate_window(resource: PackedScene) -> void:
	var window := WINDOW.instantiate()
	var thing := resource.instantiate()
	window.get_node("VBoxContainer").add_child(thing)
	thing.mouse_filter = MouseFilter.MOUSE_FILTER_PASS
	window.gui_input.connect(func (event: InputEvent):
		if event is InputEventMouseButton and event.pressed:
			desktop_area.move_child(window, desktop_area.get_child_count() - 1)
			print_tree_pretty()
			print(1)
		)
	desktop_area.add_child(window)
	thing.grab_focus()


func _on_window_focused(focused_window):
	# Raise the focused window to the top
	focused_window.raise()


func _on_terminal_app_pressed() -> void:
	instatentiate_window(TERMINAL)


func _on_man_button_pressed() -> void:
	if tutorial_label != null:
		tutorial_label.queue_free()
	instatentiate_window(MANUAL)


func _on_turn_off_button_pressed() -> void:
	get_tree().quit()


func _on_level_1_app_pressed() -> void:
	instatentiate_window(LEVEL)
