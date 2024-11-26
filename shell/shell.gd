class_name Shell
extends Node

@export var level_path := "res://level/level1_root"
@onready var vsf: VirtualFileSystem = VirtualFileSystem.new(level_path)
const bin := preload("res://shell/bin.gd")

func _init() -> void:
	vsf = VirtualFileSystem.new(level_path)



func execute(commands: String) -> CommandResult:
	var prepared_commands = prepare_commands(commands)
	var commands_exist := check_commands(prepared_commands)
	if commands_exist.termination_status == CommandResult.TerminationStatus.EXIT_FAILURE:
		return commands_exist

	var previous_command: CommandResult = CommandResult.new("", CommandResult.TerminationStatus.EXIT_SUCCESS)
	for i in range(prepared_commands.size()):
		if previous_command.termination_status == CommandResult.TerminationStatus.EXIT_FAILURE:
			return previous_command
		var command_name = prepared_commands[i][0]
		var args = prepared_commands[i].slice(1, prepared_commands[i].size())
		var is_pipe = (i > 0)  # Only set is_pipe to true if this is not the first command
		
		previous_command = bin.bin_dict[command_name].call(args, is_pipe, previous_command)
	
	return previous_command


func prepare_commands(commands: String) -> Array:
	var prepared := []
	var pipeline := commands.strip_edges().split("|")
	for i in range(pipeline.size()):
		var args := pipeline[i].strip_edges().split(" ")
		var prepared_args := []
		for a in args:
			prepared_args.append(a.strip_edges())
		prepared.append(prepared_args)
	return prepared


func command_not_found(command: String) -> String:
	return "DSH: %s: COMMAND NOT FOUND\n" % command


func check_commands(command: Array) -> CommandResult:
	var exists := true
	var errors: String = ""
	var incomplete_pipe := false
	for i in range(command.size()):
		if !bin.bin_dict.has(command[i][0]):
			if command[i][0] == "":
				incomplete_pipe = true
			errors += command_not_found(command[i][0])
			exists = false
	if exists:
		return CommandResult.new("", CommandResult.TerminationStatus.EXIT_SUCCESS)
	else:
		if incomplete_pipe:
			return CommandResult.new("DSH: INCOMPLETE PIPE\n", CommandResult.TerminationStatus.EXIT_FAILURE)
		else:
			return CommandResult.new(errors, CommandResult.TerminationStatus.EXIT_FAILURE)
