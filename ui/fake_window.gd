extends Control

@onready var bar: ColorRect = $VBoxContainer/HBoxContainer/Bar
@onready var close: AudioStreamPlayer = $Close
@onready var close_btn: TextureButton = $VBoxContainer/HBoxContainer/CloseBtn
const min_size := Vector2(100, 100)

# Tracks if the window is being dragged or resized
var is_moving: bool = false
var is_resizing: bool = false
var drag_offset: Vector2
var resize_dir: Vector2 = Vector2.ZERO

signal got_focus

func _ready() -> void:
	bar.mouse_filter = MouseFilter.MOUSE_FILTER_PASS
	close_btn.mouse_filter = MouseFilter.MOUSE_FILTER_PASS

func _on_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		got_focus.emit()
		# Start dragging on left mouse button press
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			mouse_default_cursor_shape = CursorShape.CURSOR_DRAG
			is_moving = true
			drag_offset = event.position
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			mouse_default_cursor_shape = CursorShape.CURSOR_ARROW
			is_moving = false
	elif event is InputEventMouseMotion and is_moving:
		# Dragging logic
		position += event.relative

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		got_focus.emit()
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if event.pressed:
				is_resizing = true
				resize_dir = get_corner_direction(event.position)
			else:
				is_resizing = false
				resize_dir = Vector2.ZERO
		elif not event.pressed:
			is_resizing = false
	elif event is InputEventMouseMotion:
		if is_resizing:
			resize_window(event.relative)

func _on_close_finished() -> void:
	queue_free()

func _on_close_btn_pressed() -> void:
	got_focus.emit()
	close.play()

func get_corner_direction(position: Vector2) -> Vector2:
	var margin = 10
	var dir = Vector2.ZERO
	if position.x <= size.x / 2:
		dir.x = -1
	elif position.x >= size.x / 2:
		dir.x = 1
	if position.y <= size.y / 2:
		dir.y = -1
	elif position.y >= size.y / 2:
		dir.y = 1
	return dir

func resize_window(relative: Vector2) -> void:
	var new_size = size + resize_dir * relative
	var new_position = position

	if resize_dir.x != 0:  # Horizontal resizing
		new_size.x = max(new_size.x, min_size.x)
		if resize_dir.x < 0:  # Left corners
			new_position.x += size.x - new_size.x

	if resize_dir.y != 0:  # Vertical resizing
		new_size.y = max(new_size.y, min_size.y)
		if resize_dir.y < 0:  # Top corners
			new_position.y += size.y - new_size.y

	size = new_size
	position = new_position
