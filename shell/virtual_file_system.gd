class_name VirtualFileSystem
extends Node

var level_path: String

class File:
	var content: String
	var is_dir: bool
	
	func _init(content: String, is_dir: bool) -> void:
		self.content = content
		self.is_dir = is_dir

func _init(level_path: String):
	self.level_path = level_path

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
