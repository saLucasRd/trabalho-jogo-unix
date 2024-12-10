extends Control

@export var levels: Array[Node]

@onready var level_panels = $LevelPanel.get_children()

# Aux Functions
func _toggle_visibility(node: Node) -> void:
	node.visible = not node.visible

func hide_all_levels() -> void:
	for level_panel in level_panels:
		level_panel.visible = false


func _on_level_1_pressed() -> void:
	hide_all_levels()
	print("1")
	_toggle_visibility(level_panels[0])

func _on_level_2_pressed() -> void:
	hide_all_levels()
	print("2")
	_toggle_visibility(level_panels[1])

func _on_level_3_pressed() -> void:
	hide_all_levels()
	print("3")
	_toggle_visibility(level_panels[2])

func _on_level_4_pressed() -> void:
	pass # Replace with function body.
