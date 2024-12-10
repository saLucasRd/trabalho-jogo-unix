extends Control

@export var levels: Array[Node]

func _on_level_1_pressed() -> void:
	print("1")
	_toggle_visibility($Panel/Level)

func _on_level_2_pressed() -> void:
	print("2")
	_toggle_visibility($Panel/Level2)

func _on_level_3_pressed() -> void:
	print("3")
	_toggle_visibility($Panel/Level3)

func _toggle_visibility(node: Node) -> void:
	node.visible = not node.visible
