extends CharacterBody2D

var speed = 2000
var pos:Vector2
var rota:float
var dir:float

#
	
func _physics_process(delta: float) -> void:
	velocity = Vector2(cos(dir), sin(dir)) * speed
	move_and_slide()
	
	if !get_viewport_rect().has_point(global_position):
		queue_free()
