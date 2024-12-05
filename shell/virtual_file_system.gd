class_name VirtualFileSystem
extends Node

var level_path: String
var file_system: File
var current_dir: File
var current_dir_string: String


class File:
	var file_name: String
	var content: String
	var is_dir: bool
	var links: Array[File]
	var parent: File = null  # Added parent reference for easier navigation

	func _init(_file_name: String, _content: String, _is_dir: bool, _links: Array[File], _parent: File = null):
		self.file_name = _file_name
		self.content = _content
		self.is_dir = _is_dir
		self.links = _links
		self.parent = _parent


func _init(_level_path: String):
	self.level_path = _level_path
	self.file_system = _build_fs(level_path, null)
	file_system.file_name = "root"
	current_dir_string = "/"
	self.current_dir = file_system  # Set current directory to root initially
	print(_print_tree(file_system))


func _build_fs(_level_path: String, parent: File) -> File:
	var root = File.new(_level_path.get_file(), "", true, [], parent)
	var root_dir = DirAccess.open(_level_path)
	if root_dir == null:
		print("Error: Unable to open directory ", _level_path)
		return root

	var all_files = root_dir.get_files()
	var all_dir = root_dir.get_directories()
	for file in all_files:
		root.links.append(File.new(file, _read_file_content(_level_path.path_join(file)), false, [], root))

	for dir in all_dir:
		root.links.append(_build_fs(_level_path.path_join(dir), root))
	return root


func _read_file_content(file_path: String) -> String:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		return ""
	var content = file.get_as_text()
	file.close()
	return content


func _print_tree(node: File, depth: int = 0) -> String:
	var result = "  ".repeat(depth) + (node.file_name + "/" if node.is_dir else node.file_name) + "\n"
	for link in node.links:
		result += _print_tree(link, depth + 1)
	return result


func navigate_to(path: String) -> bool:
	if path == "/":
		current_dir_string = "/"
		current_dir = file_system
		return true
	var simple_path := path.simplify_path()
	var absolute := simple_path.is_absolute_path()
	var split_path := simple_path.substr(1).split("/") if absolute else simple_path.split("/")
	var target_dir: File

	if absolute:
		# Start navigation from the root if the path is absolute
		target_dir = _get_dir_from_root(split_path)
		current_dir_string = "/" + "/".join(split_path)
	else:
		# Start navigation from the current directory
		target_dir = _get_dir_from_current(split_path)
		if target_dir != null:
			current_dir_string = current_dir_string.path_join(path)

	if target_dir != null:
		current_dir = target_dir
		return true

	print("Error: Directory not found: ", path)
	return false



func _get_dir_from_root(path: Array[String]) -> File:
	var node = file_system
	return _traverse_path(node, path)


func _get_dir_from_current(path: Array[String]) -> File:
	var node = current_dir
	return _traverse_path(node, path)


func _traverse_path(node: File, path: Array[String]) -> File:
	for part in path:
		if part == ".":
			continue
		elif part == "..":
			# Navigate to parent directory
			if node.parent != null:
				node = node.parent
			else:
				return null
		else:
			var found = false
			for link in node.links:
				if link.file_name == part and link.is_dir:
					node = link
					found = true
					break
			if not found:
				return null
	return node


func read_from(path: String) -> String:
	var simple_path := path.simplify_path()
	var absolute := simple_path.is_absolute_path()
	var split_path := simple_path.substr(1).split("/") if absolute else simple_path.split("/")
	var target_file: File
	
	if absolute:
		target_file = _get_dir_from_root(split_path)
	else:
		target_file = _get_dir_from_current(split_path)
	
	if target_file and not target_file.is_dir:
		return target_file.content
	
	print("Error: File not found or is a directory: ", path)
	return ""


func list_current_dir() -> Array[String]:
	var result: Array[String] = []
	for link in current_dir.links:
		result.append(link.file_name + ("/" if link.is_dir else ""))
	return result


func pwd() -> String:
	return current_dir_string
