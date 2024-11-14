extends Control


@onready var watch: RichTextLabel = $Watch
@onready var contract: RichTextLabel = $Contract
@onready var terminal: TextEdit = $Terminal

func _on_aba_terminal_pressed() -> void:
	terminal.visible = true
	watch.visible = false
	contract.visible = false


func _on_aba_watch_pressed() -> void:
	terminal.visible = false
	watch.visible = true
	contract.visible = false


func _on_aba_contrato_pressed() -> void:
	terminal.visible = false
	watch.visible = false
	contract.visible = true
