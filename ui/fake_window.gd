extends Control

@onready var bar: ColorRect = $VBoxContainer/HBoxContainer/Bar
@onready var close: TextureButton = $VBoxContainer/HBoxContainer/Close

enum Q {
	Q1,
	Q2,
	Q3,
	Q4,
}


# Tracks if the window is being dragged
var is_left_dragging: bool = false
var is_right_dragging: bool = false
var drag_offset: Vector2

func _ready() -> void:
	bar.mouse_filter = MouseFilter.MOUSE_FILTER_PASS
	close.mouse_filter = MouseFilter.MOUSE_FILTER_PASS


func _on_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# Start dragging on left mouse button press
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			mouse_default_cursor_shape = CursorShape.CURSOR_DRAG
			is_left_dragging = true
			drag_offset = event.position
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			mouse_default_cursor_shape = CursorShape.CURSOR_ARROW
			is_left_dragging = false
	elif event is InputEventMouseMotion and is_left_dragging:
		# Dragging logic
		
		position += event.relative


func _on_close_pressed() -> void:
	queue_free()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			var direita:bool = event.position.x >= size.x / 2
			var cima:bool = event.position.y <= size.y / 2
			print(direita, cima)
			
			
			
