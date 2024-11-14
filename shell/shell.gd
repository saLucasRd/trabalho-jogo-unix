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


var command_dict := {
	"MAN": man_ls
}


func execute_command(command: String) -> String:
	var pipeline = command.strip_edges().split("|")
	
	var previous_output := ""
	for i in range(pipeline.size()):
		var args = pipeline[i].split(" ")
		if !command_dict.has(args[0]):
			return "\nDSH: " + args[0] + ": COMMAND NOT FOUND"
		
		

func man_ls(args: Array[String], is_pipe: bool) -> CommandResult:
	return CommandResult.new("
MAN [PROGRAMA]  MOSTRA AJUDA SOBRE COMANDOS
LS  [DIRETORIO] MOSTRA CONTEUDO DE DIRETORIOS
CD  DIRETORIO   MUDA DE DIRETORIO
PWD             MOSTRA DIRETORIO ATUAL
CAT ARQUIVO     MOSTRA / CONCATENA CONTEUDO DE ARQUIVOS", TerminationStatus.EXIT_SUCCESS)
