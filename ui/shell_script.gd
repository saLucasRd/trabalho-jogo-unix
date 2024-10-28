extends Control

# References to input/output fields
@onready var output_box = $TextEdit
@onready var input_box = $LineEdit

var command_history = []
var current_history_index = -1
var current_directory = "/home"
var simulated_files = {"file1.txt": "Hello World\n", "file2.txt": "Godot 4\n"}
var simulated_processes = [{"pid": 1234, "name": "daemon1"}, {"pid": 5678, "name": "daemon2"}]

func _ready():
	input_box.grab_focus()

func _on_input_box_text_entered(new_text):
	command_history.append(new_text)
	current_history_index = len(command_history)
	process_command(new_text)
	input_box.text = ""

# Parse the command, handle pipes (|) and pass output from one to another
func process_command(command):
	var commands = command.split("|")
	var output = ""
	for i in range(commands.size()):
		var cmd_output = run_command(commands[i].strip(), output)
		output = cmd_output
	output_box.append_bbcode("%s\n" % output)
	output_box.scroll_to_line(output_box.get_line_count())

# Run individual commands
func run_command(command, input_data):
	var args = command.split(" ")
	match args[0]:
		"ls":
			return ls_command()
		"cd":
			return cd_command(args[1])
		"grep":
			return grep_command(args[1], input_data)
		"wc":
			return wc_command(input_data)
		"cat":
			return cat_command(args[1])
		"diff":
			return diff_command(args[1], args[2])
		"kill":
			return kill_command(args[1])
		"free":
			return free_command()
		"ps":
			return ps_command()
		"sort":
			return sort_command(input_data)
		"uniq":
			return uniq_command(input_data)
		"head":
			return head_command(input_data)
		"tail":
			return tail_command(input_data)
		"xargs":
			return xargs_command(args.slice(1), input_data)
		"file":
			return file_command(args[1])
		"col":
			return col_command(input_data)
		_:
			return "[color=red]Unknown command: %s[/color]" % command

# Command implementations

func ls_command():
	var file_list = simulated_files.keys()
	return file_list.join("\n")

func cd_command(dir):
	current_directory = dir  # Simplified navigation for now
	return "Changed directory to %s" % dir

func grep_command(pattern, input_data):
	var result = ""
	var lines = input_data.split("\n")
	for line in lines:
		if line.find(pattern) != -1:
			result += line + "\n"
	return result

func wc_command(input_data):
	var lines = input_data.split("\n").size() - 1
	var words = input_data.split(" ").size()
	var bytes = input_data.to_utf8_buffer().size()
	return "%d %d %d" % [lines, words, bytes]

func cat_command(file_name):
	if simulated_files.has(file_name):
		return simulated_files[file_name]
	else:
		return "[color=red]No such file: %s[/color]" % file_name

func diff_command(file1, file2):
	if simulated_files.has(file1) and simulated_files.has(file2):
		return "No differences" if simulated_files[file1] == simulated_files[file2] else "Files are different"
	else:
		return "[color=red]One or both files not found[/color]"


func kill_command(pid):
	for process in simulated_processes:
		if str(process.pid) == pid:
			simulated_processes.erase(process)
			return "Killed process %s" % pid
	return "[color=red]No such process: %s[/color]" % pid

func free_command():
	return "Memory: 1024MB total, 512MB used, 512MB free"

func ps_command():
	var result = "PID   NAME\n"
	for process in simulated_processes:
		result += "%d   %s\n" % [process.pid, process.name]
	return result

func sort_command(input_data):
	var lines = input_data.split("\n")
	lines.sort()
	return lines.join("\n")

func uniq_command(input_data):
	var lines = input_data.split("\n")
	var unique_lines = lines.duplicate().erase_duplicates()
	return unique_lines.join("\n")

func head_command(input_data):
	var lines = input_data.split("\n")
	return "\n".join(lines.slice(0, min(lines.size(), 10)))

func tail_command(input_data):
	var lines = input_data.split("\n")
	return "\n".join(lines.slice(max(0, lines.size() - 10), lines.size()))

func xargs_command(args, input_data):
	# Example: takes arguments and appends them to the input_data (simulating)
	return input_data + " " + args.join(" ")

func file_command(file_name):
	return "[color=blue]%s: ASCII text[/color]" % file_name if simulated_files.has(file_name) else "[color=red]No such file[/color]"

func col_command(input_data):
	# Simplified to just return the input (mocking the behavior)
	return input_data
