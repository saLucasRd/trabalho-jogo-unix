extends Node2D  # Root node of your game

var asteroid_scene = preload("res://games/asteroid.tscn")  # Preload the asteroid scene
var spawn_area = Rect2(Vector2(0, 0), Vector2())  # Define spawn area, adjusted in _ready()

# Timer for random spawn intervals
var spawn_timer = Timer.new()
var min_spawn_time = 1.0  # Minimum time between spawns
var max_spawn_time = 3.0  # Maximum time between spawns

func _ready() -> void:
	# Set spawn area size to viewport size
	spawn_area.size = get_viewport_rect().size

	# Add and configure the spawn timer
	add_child(spawn_timer)
	spawn_timer.connect("timeout", Callable(self, "_spawn_asteroid"))
	_reset_spawn_timer()

func _reset_spawn_timer() -> void:
	# Set a random interval for the spawn timer
	spawn_timer.wait_time = randf_range(min_spawn_time, max_spawn_time)
	spawn_timer.start()

func _spawn_asteroid() -> void:
	var asteroid = asteroid_scene.instantiate()

	# Ensure asteroid has the required script
	if asteroid.has_method("set_direction"):
		asteroid.direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
	else:
		print("Error: The instantiated asteroid does not have a 'direction' property.")

	# Set random position
	asteroid.global_position = Vector2(
		randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
		randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	)

	add_child(asteroid)  # Add asteroid to the scene

	# Reset spawn timer
	_reset_spawn_timer()
