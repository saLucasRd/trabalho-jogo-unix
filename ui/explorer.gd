extends Control

@export var scene_to_instance: PackedScene

func _ready() -> void:
	$Panel2/VBoxContainer/Level1Container/Level1.pressed.connect(_on_level_1_pressed)
	$Panel2/VBoxContainer/Level2Container/Level2.pressed.connect(_on_level_2_pressed)
	$Panel2/VBoxContainer/Level3Container/Level3.pressed.connect(_on_level_3_pressed)

func _on_level_1_pressed() -> void:
	print("pressed")
	if scene_to_instance:
		var new_scene = scene_to_instance.instantiate()
		$Panel.add_child(new_scene)
		#new_scene.position = Vector2(70, 0)


func _on_level_2_pressed() -> void:
	print("pressed")
	if scene_to_instance:
		var new_scene = scene_to_instance.instantiate()
		$Panel.add_child(new_scene)


func _on_level_3_pressed() -> void:
	print("pressed")
	if scene_to_instance:
		var new_scene = scene_to_instance.instantiate()
		$Panel.add_child(new_scene)
