extends Control

@onready var text_edit: TextEdit = $TextEdit
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	text_edit.scroll_fit_content_height = true

func _process(delta: float) -> void:
	text_edit.text += junk_generator()

func junk_generator() -> String:
	var a := ""
	for i in range(20):
		a += char(randi_range(32,200))
	return a

func _on_audio_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://ui/desktop.tscn")
