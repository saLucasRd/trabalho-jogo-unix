extends Control

@export var scene_to_instance: PackedScene

func _ready() -> void:
	$Panel2/VBoxContainer/Level1Container/Level1.pressed.connect(_on_level_1_pressed)

func _on_level_1_pressed() -> void:
	print("pressed")
	if scene_to_instance:
		var new_scene = scene_to_instance.instantiate()
		$Panel.add_child(new_scene)
		#new_scene.position = Vector2(70, 0)
