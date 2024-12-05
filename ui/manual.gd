extends Control

var pages = []
var current_page_index = 0

func _ready():
	pages = [
		$"VBoxContainer/Control/Page1-2",
		$"VBoxContainer/Control/Page3-4",
		$"VBoxContainer/Control/Page5-6",
		$"VBoxContainer/Control/Page7-8",
		$"VBoxContainer/Control/Page9-10",
		$"VBoxContainer/Control/Page11-12"
	]
	
	print("Total pages loaded: ", pages.size())
	
	# Verify that all pages are valid
	for i in range(pages.size()):
		if pages[i] == null:
			print("Error: Page ", i+1, " is null. Check the node path.")
		else:
			pages[i].visible = (i == current_page_index)
			print("Page ", i+1, " visibility set to ", pages[i].visible)

func _on_previous_page_pressed() -> void:
	if current_page_index > 0:
		pages[current_page_index].visible = false
		print("Hiding page ", current_page_index + 1)
		current_page_index -= 1
		pages[current_page_index].visible = true
		print("Showing page ", current_page_index + 1)
	else:
		print("Already on the first page.")

func _on_next_page_pressed() -> void:
	if current_page_index < pages.size() - 1:
		pages[current_page_index].visible = false
		print("Hiding page ", current_page_index + 1)
		current_page_index += 1
		pages[current_page_index].visible = true
		print("Showing page ", current_page_index + 1)
	else:
		print("You are on the last page.")

func _on_index_pressed() -> void:
	if current_page_index != 0:
		pages[current_page_index].visible = false  
		print("Hiding page ", current_page_index + 1)
		current_page_index = 0
		pages[current_page_index].visible = true
		print("Showing page ", current_page_index + 1)
	else:
		print("Already on the first page.")
