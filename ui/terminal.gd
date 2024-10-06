extends TextEdit

var current_directory: String = "home/user"  # Starting directory
var command_buffer: String = ""  # Buffer to hold the current command

func _ready():
	# Start by displaying the initial prompt
	print_prompt()

func _input(event):
	if event is InputEventKey and event.pressed:  # Ensure the event is a key event
		match event.keycode:
			KEY_ENTER:
				execute_command(command_buffer)
				command_buffer = ""  # Clear the command buffer after execution
				print_prompt()  # Print the prompt again after command execution
			KEY_BACKSPACE:
				if command_buffer.length() > 0:
					command_buffer = command_buffer.substr(0, command_buffer.length() - 1)
					# Update TextEdit display
					self.text = self.text.substr(0, self.text.length() - 1)  # Remove last char from TextEdit
			KEY_ESCAPE:
				self.clear()  # Clear the terminal
				command_buffer = ""  # Reset command buffer
				print_prompt()  # Show the prompt again
			_:
				# Capture the character input
				command_buffer += OS.get_keycode_string(event.keycode)  # Get the character from keycode
				self.text += OS.get_keycode_string(event.keycode)  # Display it in TextEdit

func print_prompt():
	self.text += "\n> " + current_directory + " "  # Display the prompt

func execute_command(command: String):
	match command.strip_edges():
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
