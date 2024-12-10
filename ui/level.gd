extends Control

@export var question: String = ""
@export var expected_answer: String = ""
@export var level_path: String = ""

@onready var question_label = $Label
@onready var answer_input = $LineEdit
@onready var submit_button = $Button

func _ready():
	# Set the question text
	question_label.text = question


func _on_submit_pressed():
	var player_answer = answer_input.text.strip_edges().to_lower()
	if player_answer == expected_answer.strip_edges().to_lower():
		print("Correct! Moving to the next level.")
		# Handle correct answer logic (e.g., load the next level)
	else:
		print("Incorrect! Try again.")
		# Handle incorrect answer logic
