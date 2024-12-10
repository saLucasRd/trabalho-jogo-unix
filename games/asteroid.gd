extends CharacterBody2D

# Properties for asteroid movement and size
var direction: Vector2 = Vector2()  # Direction the asteroid will move
var speed: float = 100.0  # Speed of the asteroid
var size: int = 3  # Size of the asteroid (3 = large, 2 = medium, 1 = small)

func _ready() -> void:
	# Scale the asteroid sprite based on its size
	$Sprite2D.scale = Vector2(size, size)
	
	# Randomize direction if not already set
	if direction == Vector2():
		direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()

func _physics_process(delta: float) -> void:
	# Move the asteroid in its direction
	velocity = direction * speed
	move_and_slide()

	# Wrap around the screen edges
	wrap_around_screen()

func wrap_around_screen() -> void:
	# Wraps the asteroid around the screen if it goes offscreen
	var screen_size = get_viewport_rect().size
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0

func split() -> void:
	# Splits the asteroid into smaller pieces when destroyed
	if size > 1:
		for i in range(2):
			var new_asteroid = preload("res://games/asteroid.tscn").instantiate()
			new_asteroid.size = size - 1
			new_asteroid.global_position = global_position
			new_asteroid.direction = direction.rotated(randf() * PI / 4 - PI / 8)  # Slight random offset
			get_parent().add_child(new_asteroid)
	queue_free()  # Remove the current asteroid
