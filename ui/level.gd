extends Control

@export_multiline var question: String = ""
@export_multiline var expected_answer: String = ""
@export var level_name := ""
var sh: Shell = Shell.new()

signal win

@onready var question_label: RichTextLabel = $VBoxContainer2/RichTextLabel
@onready var answer_input: LineEdit = $VBoxContainer2/VBoxContainer/HBoxContainer/LineEdit
@onready var submit_button: Button = $VBoxContainer2/VBoxContainer/HBoxContainer/Button
@onready var error: Label = $VBoxContainer2/VBoxContainer/Error


func _ready():
	question_label.text = question

func _on_button_pressed() -> void:
	var input := answer_input.text.to_upper()
	if input.is_empty():
		error.text = "ERRO: Seu input está vazio."
	var command_res := sh.execute(input)
	if command_res.termination_status == CommandResult.TerminationStatus.EXIT_FAILURE:
		error.text = "ERRO: " + command_res.output
	else:
		if command_res.output.strip_edges() == expected_answer.strip_edges():
			win.emit()
