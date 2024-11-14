extends Control

@onready var watch: RichTextLabel = $Watch
@onready var contrato: RichTextLabel = $Contrato
@onready var terminal: TextEdit = $Terminal

func _on_aba_terminal_pressed() -> void:
	terminal.visible = true
	watch.visible = false
	contrato.visible = false


func _on_aba_watch_pressed() -> void:
	terminal.visible = false
	watch.visible = true
	contrato.visible = false


func _on_aba_contrato_pressed() -> void:
	terminal.visible = false
	watch.visible = false
	contrato.visible = true
