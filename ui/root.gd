extends Control

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			%DaemonView.grab_click_focus()
			%DaemonView.grab_focus()
			Global.on_fps_view = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Capture the mouse

		elif event.button_index == MOUSE_BUTTON_RIGHT and not event.pressed:
			Global.on_fps_view = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Restore mouse visibility
