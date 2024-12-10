extends Control
@onready var content: Control = $VBoxContainer/Content

var current_page_index = 0
var page_count = len(content.get_child_count(false))
func _ready():
	print(page_count)
	
func _on_previous_page_pressed() -> void:
	pass
	#if current_page_index > 0:
		#pages[current_page_index].visible = false
		#print("Hiding page ", current_page_index + 1)
		#current_page_index -= 1
		#pages[current_page_index].visible = true
		#print("Showing page ", current_page_index + 1)
	#else:
		#print("Already on the first page.")

func _on_next_page_pressed() -> void:
	pass
	#if current_page_index < pages.size() - 1:
		#pages[current_page_index].visible = false
		#print("Hiding page ", current_page_index + 1)
		#current_page_index += 1
		#pages[current_page_index].visible = true
		#print("Showing page ", current_page_index + 1)
	#else:
		#print("You are on the last page.")

func _on_index_pressed() -> void:
	pass
	#if current_page_index != 0:
		#pages[current_page_index].visible = false  
		#print("Hiding page ", current_page_index + 1)
		#current_page_index = 0
		#pages[current_page_index].visible = true
		#print("Showing page ", current_page_index + 1)
	#else:
		#print("Already on the first page.")
