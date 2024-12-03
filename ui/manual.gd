extends Control

@onready var page_1n2 = get_node("Page1-2")
@onready var page_3n4 = get_node("Page3-4")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_page_pressed() -> void:
	if page_1n2.visible == true:
		page_1n2.visible = false
		page_3n4.visible = true


func _on_previous_page_pressed() -> void:
	if page_3n4.visible == true:
		page_1n2.visible = true
		page_3n4.visible = false
