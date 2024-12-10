extends Control

@export var scene_to_instance: PackedScene

func _ready() -> void:
	$Panel/GridContainer/Level1.pressed.connect(_on_level_1_pressed)


func _on_level_1_pressed() -> void:
	print("pressed")
	if scene_to_instance:
		var new_scene = scene_to_instance.instantiate()
		add_child(new_scene)
		
