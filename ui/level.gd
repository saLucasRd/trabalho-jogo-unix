extends Control

@export var question: String = ""
@export var expected_answer: String = ""
@export var level_path: String = ""

signal win

@onready var question_label: RichTextLabel = $VBoxContainer2/RichTextLabel
@onready var answer_input: LineEdit = $VBoxContainer2/VBoxContainer/HBoxContainer/LineEdit
@onready var submit_button: Button = $VBoxContainer2/VBoxContainer/HBoxContainer/Button
@onready var error: Label = $VBoxContainer2/VBoxContainer/Error

func _ready():
	question_label.text = question


func _on_button_pressed() -> void:
	if answer_input.text.is_empty():
		error.text = "ERRO: Seu input está vazio."
	var player_answer = answer_input.text.strip_edges().to_lower()
	if player_answer == expected_answer.strip_edges().to_lower():
		print("Correct! Moving to the next level.")
		# Handle correct answer logic (e.g., load the next level)
	else:
		print("Incorrect! Try again.")
		# Handle incorrect answer logic
