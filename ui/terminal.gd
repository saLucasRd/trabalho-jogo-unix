extends TextEdit

const ROOT_DIR := "res://level/root"
const MAX_LINES: int = 50
const CARET: String = "█"
var current_directory: String = "."
var command_buffer: String = ""


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


func execute_command(command: String):
	remove_last_caret()
	var pipe_args = command.strip_edges().split("|")
	for i in range(pipe_args.size()):
		var args = pipe_args[i].split(" ")
		match args[0]:
			"":
				pass
			"MAN":
				self.text += "
MAN [PROGRAMA]  MOSTRA AJUDA SOBRE COMANDOS
LS  [DIRETORIO] MOSTRA CONTEUDO DE DIRETORIOS
CD  DIRETORIO   MUDA DE DIRETORIO
PWD             MOSTRA DIRETORIO ATUAL
CAT ARQUIVO     MOSTRA / CONCATENA CONTEUDO DE ARQUIVOS"
			"CD":
				pass
					
			"PWD":
				self.text += "\n" + current_directory
			"LS":
				pass
			_:
				self.text += "\nDSH: " + args[0] + ": COMMAND NOT FOUND"

func bin_ls(arg: String, is_pipe: bool) -> bool:
	var dir = DirAccess.open(arg)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				self.text += "\ndir: " + file_name
			else:
				self.text +=  "\nfile: " + file_name
				file_name = dir.get_next()
		return true
	else:
		return false

func bin_cs(arg: String, is_pipe: bool):
	pass
