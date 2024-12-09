extends CharacterBody2D

var speed = 2000
var pos:Vector2
var rota:float
var dir:float

func _ready() -> void:
	global_position=pos
	global_rotation=rota
	
func _physics_process(delta: float) -> void:
	velocity=Vector2(speed,0).rotated(dir)
	move_and_slide()
