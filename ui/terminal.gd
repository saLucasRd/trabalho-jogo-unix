extends TextEdit

const ROOT_DIR := "res://level/root"
const MAX_LINES: int = 50
const CARET: String = "█"
var current_directory: String = "."
var command_buffer: String = ""
var simulated_files = {"file1.txt": "Hello World\n", "file2.txt": "Godot 4\n"}
var simulated_processes = [{"pid": 1234, "name": "daemon1"}, {"pid": 5678, "name": "daemon2"}]

func _ready():
	current_directory = ROOT_DIR
	prepare_prompt()

func _input(event):
	if event is InputEventKey and event.pressed and !Global.on_fps_view:
		match event.keycode:
			KEY_ENTER:
				execute_command(command_buffer)
				prepare_prompt()
			KEY_BACKSPACE:
				if command_buffer.length() > 0:
					command_buffer = command_buffer.substr(0, command_buffer.length() - 1)
					self.text = self.text.substr(0, self.text.length() - 2)
					self.text += CARET
			KEY_ESCAPE:
				self.clear()
				prepare_prompt()
			KEY_SPACE:
				remove_last_caret()
				command_buffer += " "
				self.text += " " + CARET
			_:
				# Handle other inputs for letters and special keys
				if event.keycode == clamp(event.keycode, 64, 90) or event.keycode == clamp(event.keycode, 48, 57):
					update_caret(OS.get_keycode_string(event.keycode))
				if event.keycode == KEY_PERIOD:
					update_caret(".")
				if Input.is_action_pressed("pipe"):
					update_caret("|")
				if Input.is_action_just_pressed("underscore"):
					update_caret("_")
		limit_text()
		scroll_to_bottom()

func remove_last_caret():
	self.text = self.text.substr(0, self.text.length() - 1)

func update_caret(new_char: String):
	command_buffer += new_char
	remove_last_caret()
	if new_char != " ":
		self.text += new_char + CARET
	if new_char == " ":
		self.text += CARET

func prepare_prompt():
	command_buffer = ""
	print_prompt()

func print_prompt():
	self.text += "\n$ " + CARET

func limit_text():
	var lines = self.text.split("\n")
	if lines.size() > MAX_LINES:
		var start_index = lines.size() - MAX_LINES
		self.text = "\n".join(lines.slice(start_index, lines.size()))

func scroll_to_bottom():
	self.scroll_vertical = self.get_line_count()

# Core function to execute a command, handle pipes (|), and pass output from one command to another.
func execute_command(command: String):
	remove_last_caret()
	var pipe_args = command.strip_edges().split("|")
	var output = ""
	
	# Handle piping
	for i in range(pipe_args.size()):
		var args = pipe_args[i].split(" ")
		output = run_command(args, output)  # Pass the previous output as input to the next command
		
	self.text += output  # Display final output after all commands
	limit_text()
	scroll_to_bottom()

# Function to execute each command
func run_command(args: Array, input_data: String) -> String:
	match args[0].to_upper():
		"MAN":
			return "\nMAN [PROGRAMA]  MOSTRA AJUDA SOBRE COMANDOS\nLS  [DIRETORIO] MOSTRA CONTEUDO DE DIRETORIOS\nCD  DIRETORIO   MUDA DE DIRETORIO\nPWD             MOSTRA DIRETORIO ATUAL\nCAT ARQUIVO     MOSTRA / CONCATENA CONTEUDO DE ARQUIVOS\n"
		"CD":
			return bin_cd(args)
		"PWD":
			return "\n" + current_directory
		"LS":
			return bin_ls(current_directory)
		"CAT":
			return bin_cat(args)
		"DIFF":
			return bin_diff(args)
		"WC":
			return bin_wc(input_data)
		"PS":
			return bin_ps()
		"SORT":
			return bin_sort(input_data)
		"UNIQ":
			return bin_uniq(input_data)
		"KILL":
			return bin_kill(args)
		_:
			return "\nDSH: " + args[0] + ": COMMAND NOT FOUND"

# Command implementations

func bin_cd(args: Array) -> String:
	if args.size() > 1:
		current_directory = args[1]  # Just updating the directory (simplified)
		return "\nChanged directory to " + args[1]
	return "\nDSH: CD: Missing argument"

func bin_ls(dir: String) -> String:
	var dir_access = DirAccess.open(dir)
	if dir_access:
		var output = "\n"
		dir_access.list_dir_begin()
		var file_name = dir_access.get_next()
		while file_name != "":
			output += file_name + "  "
			file_name = dir_access.get_next()
		return output
	return "\nDSH: LS: Directory not found"

func bin_cat(args: Array) -> String:
	if args.size() > 1 and simulated_files.has(args[1]):
		return simulated_files[args[1]]
	else:
		return "\nDSH: CAT: No such file"

func bin_diff(args: Array) -> String:
	if args.size() > 2 and simulated_files.has(args[1]) and simulated_files.has(args[2]):
		return "No differences\n" if simulated_files[args[1]] == simulated_files[args[2]] else "Files are different\n"
	else:
		return "\nDSH: DIFF: One or both files not found"

func bin_wc(input_data: String) -> String:
	var lines = input_data.split("\n").size() - 1
	var words = input_data.split(" ").size()
	var bytes = input_data.to_utf8_buffer().size()
	return "%d %d %d\n" % [lines, words, bytes]

func bin_ps() -> String:
	var result = "\nPID   NAME\n"
	for process in simulated_processes:
		result += "%d   %s\n" % [process.pid, process.name]
	return result

func bin_sort(input_data: String) -> String:
	var lines = input_data.split("\n")
	lines.sort()
	return "\n".join(lines) + "\n"

func bin_uniq(input_data: String) -> String:
	var lines = input_data.split("\n")
	var unique_lines = []
	var seen_lines = {}
	
	# Iterate over lines and add only unique ones to unique_lines
	for line in lines:
		if not seen_lines.has(line):
			unique_lines.append(line)
			seen_lines[line] = true
	
	return "\n".join(unique_lines) + "\n"


func bin_kill(args: Array) -> String:
	if args.size() > 1:
		var pid_to_kill = int(args[1])
		for i in range(simulated_processes.size()):
			if simulated_processes[i].pid == pid_to_kill:
				simulated_processes.remove(i)
				return "\nProcess %d killed\n" % pid_to_kill
		return "\nDSH: KILL: No such process"
	return "\nDSH: KILL: Missing argument"
