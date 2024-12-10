extends Control

@onready var content: HBoxContainer = $VBoxContainer/Content
@onready var current_page_index = 0
@onready var pages = content.get_children()
@onready var page_count = len(pages)

func _ready():
	print(pages)

func _on_previous_page_pressed() -> void:
	if current_page_index > 0:
		pages[current_page_index].visible = false
		pages[current_page_index + 1].visible = false
		current_page_index -= 2
		pages[current_page_index].visible = true
		pages[current_page_index + 1].visible = true

func _on_next_page_pressed() -> void:
	if current_page_index < page_count - 2:
		pages[current_page_index].visible = false
		pages[current_page_index + 1].visible = false
		current_page_index += 2
		pages[current_page_index].visible = true
		pages[current_page_index + 1].visible = true

func _on_index_pressed() -> void:
	if current_page_index != 0:
		pages[current_page_index].visible = false
		pages[current_page_index + 1].visible = false
		current_page_index = 2
		pages[current_page_index].visible = true
		pages[current_page_index + 1].visible = true


func _on_comandos_btn_pressed() -> void:
	pages[current_page_index].visible = false
	pages[current_page_index + 1].visible = false
	current_page_index = 10
	pages[current_page_index].visible = true
	pages[current_page_index + 1].visible = true


func _on_tutorial_btn_pressed() -> void:
	pages[current_page_index].visible = false
	pages[current_page_index + 1].visible = false
	current_page_index = 4
	pages[current_page_index].visible = true
	pages[current_page_index + 1].visible = true
