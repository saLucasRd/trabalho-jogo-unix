class_name VirtualFileSystem
extends Node

var level_path: String
var file_system: File

class File:
	var name: String
	var content: String
	var is_dir: bool
	var links: Array[File]
	
	func _init(name: String, content: String, is_dir: bool, links: Array[File]) -> void:
		self.name = name
		self.content = content
		self.is_dir = is_dir
		self.links = links

func _init(level_path: String):
	self.level_path = level_path

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
