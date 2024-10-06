extends Control

const MUTE = preload("res://ui/icons/mute.svg")
const UNMUTE = preload("res://ui/icons/unmute.svg")
const PLAY = preload("res://ui/icons/play.svg")
const PAUSE = preload("res://ui/icons/pause.svg")

@onready var previous: Button = $VBoxContainer/HBoxContainer/Previous
@onready var next: Button = $VBoxContainer/HBoxContainer/Next
@onready var audio_stream_player: AudioStreamPlayer = $VBoxContainer/AudioStreamPlayer
@onready var label: Label = $VBoxContainer/Label
@onready var play_pause: Button = $VBoxContainer/HBoxContainer/PlayPause
@onready var unmute_mute: Button = $VBoxContainer/HBoxContainer/UnmuteMute
@onready var volume: HSlider = $VBoxContainer/HBoxContainer/Control/Volume
@onready var status: HSlider = $VBoxContainer/Status

var collection: Array[AudioStream] = []
var index: int = 0
var playing = false

func _ready() -> void:
	var music_dir = DirAccess.get_files_at("res://audio/music")
	for m in music_dir:
		if m.ends_with(".mp3"):
			collection.append(load("res://audio/music/" + m))
	collection.shuffle()
	label.text = collection[index].resource_path.get_file().get_basename()
	audio_stream_player.stream = collection[index]
	
func update_song():
	label.text = collection[index].resource_path.get_file().get_basename()
	audio_stream_player.stream = collection[index]


func _on_previous_pressed() -> void:
	if index == 0:
		index = len(collection) - 1
	else:
		index -= 1
	update_song()
	audio_stream_player.play()
	play_pause.icon = PAUSE


func _on_next_pressed() -> void:
	if index == len(collection) - 1:
		index = 0
	else:
		index += 1
	update_song()
	audio_stream_player.play()
	play_pause.icon = PAUSE


func _on_audio_stream_player_finished() -> void:
	if index == len(collection) - 1:
		index = 0
	else:
		index += 1
	update_song()
	audio_stream_player.play()

func _on_play_pause_pressed() -> void:
	if !playing:
		playing = true
		audio_stream_player.play()
		play_pause.icon = PAUSE
	else:
		playing = false
		audio_stream_player.stop()
		play_pause.icon = PLAY


func _on_unmute_mute_pressed() -> void:
	pass


func _on_volume_value_changed(value: float) -> void:
	audio_stream_player.volume_db = value
