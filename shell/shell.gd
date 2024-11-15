class_name Shell
extends Node

@export var level_path := "res://level/level1_root/"
@onready var vsf: VirtualFileSystem = VirtualFileSystem.new(level_path)

enum TerminationStatus {
	EXIT_SUCCESS,
	EXIT_FAILURE
}

class CommandResult:
	var output: String
	var termination_status: TerminationStatus
	
	func _init(output: String, termination_status: TerminationStatus) -> void:
		self.output = output
		self.termination_status = termination_status


func execute(commands: String) -> CommandResult:
	var prepared_commands = prepare_commands(commands)
	print(prepared_commands)
	var commands_exist := all_commands_exist(prepared_commands)
	if commands_exist.termination_status == TerminationStatus.EXIT_FAILURE:
		return commands_exist

	var previous_command: CommandResult = CommandResult.new("", TerminationStatus.EXIT_SUCCESS)
	for i in range(prepared_commands.size()):
		var command_name = prepared_commands[i][0]
		var args = prepared_commands[i].slice(1, prepared_commands[i].size())
		var is_pipe = (i > 0)  # Only set is_pipe to true if this is not the first command
		
		previous_command = command_dict[command_name].call(args, is_pipe, previous_command)
	
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


func all_commands_exist(command: Array) -> CommandResult:
	var exists := true
	var errors: String = ""
	for i in range(command.size()):
		if !command_dict.has(command[i][0]):
			if errors != "":
				errors += "\n"
			errors += command_not_found(command[i][0])
			exists = false
	if exists:
		return CommandResult.new("", TerminationStatus.EXIT_SUCCESS)
	else:
		return CommandResult.new(errors, TerminationStatus.EXIT_FAILURE)


### COMANDOS ###
var command_dict := {
	"MAN": man_bin,
	"LS": ls_bin,
	"CD": cd_bin,
	"PWD": pwd_bin,
	"ECHO": echo_bin,
}

func man_bin(args: Array, is_pipe: bool, previous_command: CommandResult) -> CommandResult:
	print(is_pipe)
	print("Previous Command Output:", previous_command.output)
	print(args)
	return CommandResult.new(
"MAN [PROGRAMA]  MOSTRA AJUDA SOBRE COMANDOS
LS  [DIRETORIO] MOSTRA CONTEUDO DE DIRETORIOS
CD  DIRETORIO   MUDA DE DIRETORIO
PWD             MOSTRA DIRETORIO ATUAL
CAT ARQUIVO     MOSTRA / CONCATENA CONTEUDO DE ARQUIVOS\n", TerminationStatus.EXIT_SUCCESS)

func ls_bin(args: Array, is_pipe: bool, previous_command: CommandResult) -> CommandResult:
	print(is_pipe)
	print("Previous Command Output:", previous_command.output)
	print(args)
	# Simulação do comando LS
	var output = "FILES: " + (args[0] if args.size() > 0 else ".") + "\n"
	return CommandResult.new(output, TerminationStatus.EXIT_SUCCESS)


func cd_bin(args: Array, is_pipe: bool, previous_command: CommandResult) -> CommandResult:
	print(is_pipe)
	print("Previous Command Output:", previous_command.output)
	print(args)
	# Simulação do comando CD
	if args.size() > 0:
		var dir = args[0]
		return CommandResult.new("DIR CHANGED TO: \n" + dir, TerminationStatus.EXIT_SUCCESS)
	else:
		return CommandResult.new("ERROR: NO DIR ESPECIFIED.\n", TerminationStatus.EXIT_FAILURE)


func pwd_bin(args: Array, is_pipe: bool, previous_command: CommandResult) -> CommandResult:
	print(is_pipe)
	print("Previous Command Output:", previous_command.output)
	print(args)
	# Simulação do comando PWD
	var output = "/HOME/USER\n"  # Exemplo de saída do diretório
	return CommandResult.new(output, TerminationStatus.EXIT_SUCCESS)


func echo_bin(args: Array, is_pipe: bool, previous_command: CommandResult) -> CommandResult:
	print(is_pipe)
	print("Previous Command Output:", previous_command.output)
	print(args)
	# Simulação do comando ECHO
	var a = PackedStringArray(args)
	var output = " ".join(a) + "\n"
	return CommandResult.new(output, TerminationStatus.EXIT_SUCCESS)
