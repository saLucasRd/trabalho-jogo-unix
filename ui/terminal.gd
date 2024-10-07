extends TextEdit

var current_directory: String = "/"  # Starting directory
var command_buffer: String = ""  # Buffer to hold the current command
const MAX_LINES: int = 1000  # You can set this to a desired limit
const CARET: String = "▋"
func _ready():
	prepare_prompt()

func _input(event):
	if event is InputEventKey and event.pressed and !Global.on_fps_view:  # Ensure the event is a key event
		match event.keycode:
			KEY_ENTER:
				execute_command(command_buffer)
				prepare_prompt()
			KEY_BACKSPACE:
				if command_buffer.length() > 0:
					command_buffer = command_buffer.substr(0, command_buffer.length() - 1)  # Remove last char from buffer
					# Update the text to reflect the backspace without removing the caret
					self.text = self.text.substr(0, self.text.length() - 2)  # Remove the char before the caret
					self.text += CARET # Add the caret back
			KEY_ESCAPE:
				self.clear()  # Clear the terminal
				prepare_prompt()
			_:
				# Capture the character input
				command_buffer += OS.get_keycode_string(event.keycode)  # Get the character from keycode
				self.text = self.text.substr(0, self.text.length() - 1)  # Remove the old caret
				self.text += OS.get_keycode_string(event.keycode) + CARET  # Display the text with caret
		limit_text()
		scroll_to_bottom()

func prepare_prompt():
	command_buffer = ""  # Reset command buffer
	print_prompt()  # Show the prompt again

func print_prompt():
	self.text += "\n$ " + CARET  # Display the prompt with caret

func limit_text():
	var lines = self.text.split("\n")  # Split the text into lines
	if lines.size() > MAX_LINES:
		# Calculate the starting index for slicing
		var start_index = lines.size() - MAX_LINES
		self.text = "\n".join(lines.slice(start_index, lines.size()))

func scroll_to_bottom():
	self.scroll_vertical = self.get_line_count()

func execute_command(command: String):
	self.text = self.text.substr(0, self.text.length() - 1)  # Remove the old caret before executing the command
	match command.strip_edges():
		"":
			pass
		"ls":
			self.text += "\nfile1.txt\nfile2.txt\nfolder1\n"
		"cd folder1":
			current_directory = "home/user/folder1"
			self.text += "\nChanged directory to folder1"
		"cd ..":
			current_directory = "home/user"
			self.text += "\nChanged directory to user"
		_:
			self.text += "\nCommand not found: " + command
	limit_text()
	scroll_to_bottom()

# Called every time the timer times out to blink the caret
func _on_caret_blink():
	# Remove the old caret and add the new one
	self.text = self.text.substr(0, self.text.length() - 1)  # Remove the last caret
	self.text += CARET # Add the new caret at the end
