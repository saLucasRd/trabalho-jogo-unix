class_name Shell
extends Node

var vfs: VirtualFileSystem 

func _ready() -> void:
	vfs = VirtualFileSystem.new()

func execute_command(command: String) -> String:
	var pipe_args = command.strip_edges().split("|")
	for i in range(pipe_args.size()):
		var args = pipe_args[i].split(" ")
		match args[0]:
			"":
				return ""
			"MAN":
				return "
MAN [PROGRAMA]  MOSTRA AJUDA SOBRE COMANDOS
LS  [DIRETORIO] MOSTRA CONTEUDO DE DIRETORIOS
CD  DIRETORIO   MUDA DE DIRETORIO
PWD             MOSTRA DIRETORIO ATUAL
CAT ARQUIVO     MOSTRA / CONCATENA CONTEUDO DE ARQUIVOS"
			"CD":
				return ""
					
			"PWD":
				return ""
			"LS":
				return ""
			_:
				return "\nDSH: " + args[0] + ": COMMAND NOT FOUND"
	return ""

func bin_ls(arg: String, is_pipe: bool) -> bool:
	var dir = DirAccess.open(arg)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				return "\ndir: " + file_name
			else:
				return  "\nfile: " + file_name
		return true
	else:
		return false

func bin_cs(arg: String, is_pipe: bool):
	pass
