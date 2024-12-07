extends TextEdit

const MAX_LINES: int = 50
const CARET: String = "_"
var current_directory: String = "."
var command_buffer: String = ""
var sh: Shell = Shell.new()


func _ready():
	prepare_prompt()


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
	self.text += "$ " + CARET


func limit_text():
	var lines = self.text.split("\n")
	if lines.size() > MAX_LINES:
		var start_index = lines.size() - MAX_LINES
		self.text = "\n".join(lines.slice(start_index, lines.size()))


func scroll_to_bottom():
	self.scroll_vertical = self.get_line_count()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if Input.is_key_pressed(KEY_CTRL):
			match event.keycode:
				KEY_C:
					update_caret("^C")
					remove_last_caret()
					self.text += "\n"
					prepare_prompt()
				KEY_L:
					self.clear()
					prepare_prompt()
					
			

		if event.shift_pressed:
			match event.keycode:
				KEY_BACKSLASH:
					update_caret("|")
				KEY_MINUS:
					update_caret("_")

		if !event.shift_pressed and !Input.is_key_pressed(KEY_CTRL):
			if event.keycode == clamp(event.keycode, 64, 90) or event.keycode == clamp(event.keycode, 48, 57):
				update_caret(OS.get_keycode_string(event.keycode))
			match event.keycode:
				KEY_ENTER:
					remove_last_caret()
					if command_buffer.length() > 0:
						var command := sh.execute(command_buffer)
						self.text += "\n" + command.output
					else:
						self.text += "\n"
					prepare_prompt()
				KEY_BACKSPACE:
					if command_buffer.length() > 0:
						command_buffer = command_buffer.substr(0, command_buffer.length() - 1)
						self.text = self.text.substr(0, self.text.length() - 2)
						self.text += CARET
				KEY_SPACE:
					remove_last_caret()
					command_buffer += " "
					self.text += " " + CARET
				KEY_PERIOD:
					update_caret(".")
				KEY_COMMA:
					update_caret(",")
				KEY_MINUS:
					update_caret("-")
				KEY_SLASH:
					update_caret("/")
				KEY_BACKSLASH:
					update_caret("\\")

		limit_text()
		scroll_to_bottom()
