extends CharacterBody2D

var bullet_path = preload("res://games/bullet.tscn")

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("ui_accept"):
		fire()

func fire():
	var bullet = bullet_path.instantiate()
	bullet.dir = rotation
	bullet.position = global_position + Vector2(cos(rotation), sin(rotation)) * 10  # Offset by 10 pixels
	bullet.rotation = rotation
	get_parent().add_child(bullet)
