class_name VirtualFileSystem
extends Node

var level_path: String
var file_system: File
var current_dir: File


class File:
	var file_name: String
	var content: String
	var is_dir: bool
	var links: Array[File]

	func _init(_file_name: String, _content: String, _is_dir: bool, _links: Array[File]):
		self.file_name = _file_name
		self.content = _content
		self.is_dir = _is_dir
		self.links = _links


func _init(_level_path: String):
	self.level_path = _level_path
	self.file_system = _build_fs(level_path)
	file_system.file_name = "root"


func _build_fs(_level_path: String) -> File:
	var root = File.new(_level_path.get_file(), "", true, [])
	var root_dir = DirAccess.open(_level_path)
	if root_dir == null:
		print("Erro: Não foi possível abrir o diretório ", _level_path)
		return root


	var all_files = root_dir.get_files()
	var all_dir = root_dir.get_directories()
	for file in all_files:
		root.links.append(File.new(file, _read_file_content(file), false, []))
		
	for dir in all_dir:
		root.links.append(_build_fs(_level_path.path_join(dir)))
	return root


func _read_file_content(file_path: String) -> String:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		return ""
	var content = file.get_as_text().to_upper()
	file.close()
	return content


func _print_tree(node: File, depth: int = 0) -> String:
	var result = "  ".repeat(depth) + (node.file_name + "/" if node.is_dir else node.file_name) + "\n"
	for link in node.links:
		result += _print_tree(link, depth + 1)
	return result


func navigate_to(path: String):
	var split_path := path.simplify_path().split("/")
	print(split_path)



func read_from(path: String):
	pass
