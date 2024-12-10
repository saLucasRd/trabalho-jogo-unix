extends Control

@export var levels: Array[Node]

@onready var level_panels = $Panel.get_children()

@onready var level_1_panel = $Panel/Level1
@onready var level_2_panel = $Panel/Level2
@onready var level_3_panel = $Panel/Level3
#@onready var level_4_panel = $Panel/Level

# Aux Functions
func _toggle_visibility(node: Node) -> void:
	node.visible = not node.visible

func hide_all_levels() -> void:
	for level_panel in level_panels:
		_toggle_visibility(level_panel)


func _on_level_1_pressed() -> void:
	hide_all_levels()
	print("1")
	_toggle_visibility(level_1_panel)

func _on_level_2_pressed() -> void:
	hide_all_levels()
	print("2")
	_toggle_visibility(level_2_panel)

func _on_level_3_pressed() -> void:
	hide_all_levels()
	print("3")
	_toggle_visibility(level_3_panel)

func _on_level_4_pressed() -> void:
	pass # Replace with function body.
