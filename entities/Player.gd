extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003

@onready var head = $Head
@onready var camera = $Head/Camera3D

var on_fps_view = false

func _ready():
	# Start with the mouse visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			on_fps_view = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Capture the mouse

		elif event.button_index == MOUSE_BUTTON_RIGHT and not event.pressed:
			on_fps_view = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Restore mouse visibility
	# Handle mouse movement for FPS view
	if event is InputEventMouseMotion and on_fps_view:
		# Rotate the head and camera based on mouse movement
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)

		# Clamp the camera's x rotation to prevent flipping over
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)

func _physics_process(delta: float) -> void:
	# Calculate movement direction based on input
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (head.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Only move if FPS view is active
	if direction != Vector3.ZERO and on_fps_view:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	# Move the character
	move_and_slide()
