extends Node

static var bin_dict := {
	"MAN": man_bin,
	"LS": ls_bin,
	"GREP": grep_bin,
	"ECHO": echo_bin,
	"CUT": cut_bin,
	"CD": cd_bin,
	"PWD": pwd_bin,
	"CAT": cat_bin,
	"SORT": sort_bin,
	"UNIQ": uniq_bin,
	"XARGS": xargs_bin,
	"COWSAY": cowsay_bin,
}

static func man_bin(args: Array[String], is_pipe: bool, previous_command: CommandResult) -> CommandResult:
	print(is_pipe)
	print("Previous Command Output:", previous_command.output)
	print(args)
	return CommandResult.new(
"MAN [PROGRAMA]  MOSTRA AJUDA SOBRE COMANDOS
LS  [DIRETORIO] MOSTRA CONTEUDO DE DIRETORIOS
CD  DIRETORIO   MUDA DE DIRETORIO
PWD             MOSTRA DIRETORIO ATUAL
CAT ARQUIVO     MOSTRA / CONCATENA CONTEUDO DE ARQUIVOS\n", CommandResult.TerminationStatus.EXIT_SUCCESS)

static func ls_bin(args: Array[String], is_pipe: bool, previous_command: CommandResult) -> CommandResult:
	if previous_command.termination_status == CommandResult.TerminationStatus.EXIT_FAILURE:
		return previous_command
	print(is_pipe)
	print("Previous Command Output:", previous_command.output)
	print(args)
	# Simulação do comando LS
	var output = "FILES: " + (args[0] if args.size() > 0 else ".") + "\n"
	return CommandResult.new(output, CommandResult.TerminationStatus.EXIT_SUCCESS)
	
static func grep_bin(args: Array[String], is_pipe: bool, previous_command: CommandResult) -> CommandResult:
	if previous_command.termination_status == CommandResult.TerminationStatus.EXIT_FAILURE:
		return previous_command
	print(is_pipe)
	print("Previous Command Output:", previous_command.output)
	print(args)
	# Simulação do comando LS
	var output = "FILES: " + (args[0] if args.size() > 0 else ".") + "\n"
	return CommandResult.new(output, CommandResult.TerminationStatus.EXIT_SUCCESS)


static func echo_bin(args: Array, is_pipe: bool, previous_command: CommandResult) -> CommandResult:
	if previous_command.termination_status == CommandResult.TerminationStatus.EXIT_FAILURE:
		return previous_command
	if is_pipe:
		return CommandResult.new("DSH: ECHO: ECHO DOESNT ACCEPT PIPES", CommandResult.TerminationStatus.EXIT_FAILURE)
	var a = PackedStringArray(args)
	var output = " ".join(a) + "\n"
	return CommandResult.new(output, CommandResult.TerminationStatus.EXIT_SUCCESS)

static func cut_bin(args: Array[String], is_pipe: bool, previous_command: CommandResult) -> CommandResult:
	if previous_command.termination_status == CommandResult.TerminationStatus.EXIT_FAILURE:
		return previous_command
	# Simulação do comando ECHO
	var a = PackedStringArray(args)
	var output = " ".join(a) + "\n"
	return CommandResult.new(output, CommandResult.TerminationStatus.EXIT_SUCCESS)

static func cd_bin(args: Array[String], is_pipe: bool, previous_command: CommandResult) -> CommandResult:
	if previous_command.termination_status == CommandResult.TerminationStatus.EXIT_FAILURE:
		return previous_command
	print(is_pipe)
	print("Previous Command Output:", previous_command.output)
	print(args)
	# Simulação do comando CD
	if args.size() > 0:
		var dir = args[0]
		return CommandResult.new("DIR CHANGED TO: \n" + dir, CommandResult.TerminationStatus.EXIT_SUCCESS)
	else:
		return CommandResult.new("ERROR: NO DIR ESPECIFIED.\n", CommandResult.TerminationStatus.EXIT_FAILURE)


static func pwd_bin(args: Array[String], is_pipe: bool, previous_command: CommandResult) -> CommandResult:
	if previous_command.termination_status == CommandResult.TerminationStatus.EXIT_FAILURE:
		return previous_command
	print(is_pipe)
	print("Previous Command Output:", previous_command.output)
	print(args)
	# Simulação do comando PWD
	var output = "/HOME/USER\n"  # Exemplo de saída do diretório
	return CommandResult.new(output, CommandResult.TerminationStatus.EXIT_SUCCESS)

static func cat_bin(args: Array[String], is_pipe: bool, previous_command: CommandResult) -> CommandResult:
	if previous_command.termination_status == CommandResult.TerminationStatus.EXIT_FAILURE:
		return previous_command
	print(is_pipe)
	print("Previous Command Output:", previous_command.output)
	print(args)
	if args.size() > 0:
		var output = "CONTEÚDO DO ARQUIVO " + args[0] + "\nEXEMPLO DE TEXTO NO ARQUIVO.\n"
		return CommandResult.new(output, CommandResult.TerminationStatus.EXIT_SUCCESS)
	else:
		return CommandResult.new("ERRO: NENHUM ARQUIVO ESPECIFICADO.\n", CommandResult.TerminationStatus.EXIT_FAILURE)

static func sort_bin(args: Array[String], is_pipe: bool, previous_command: CommandResult) -> CommandResult:
	if previous_command.termination_status == CommandResult.TerminationStatus.EXIT_FAILURE:
		return previous_command
	print(is_pipe)
	print("Previous Command Output:", previous_command.output)
	print(args)
	# Simulação do comando LS
	var output = "FILES: " + (args[0] if args.size() > 0 else ".") + "\n"
	return CommandResult.new(output, CommandResult.TerminationStatus.EXIT_SUCCESS)

static func uniq_bin(args: Array[String], is_pipe: bool, previous_command: CommandResult) -> CommandResult:
	if previous_command.termination_status == CommandResult.TerminationStatus.EXIT_FAILURE:
		return previous_command
	print(is_pipe)
	print("Previous Command Output:", previous_command.output)
	print(args)
	# Simulação do comando LS
	var output = "FILES: " + (args[0] if args.size() > 0 else ".") + "\n"
	return CommandResult.new(output, CommandResult.TerminationStatus.EXIT_SUCCESS)

static func xargs_bin(args: Array[String], is_pipe: bool, previous_command: CommandResult) -> CommandResult:
	if previous_command.termination_status == CommandResult.TerminationStatus.EXIT_FAILURE:
		return previous_command
	print(is_pipe)
	print("Previous Command Output:", previous_command.output)
	print(args)
	# Simulação do comando LS
	var output = "FILES: " + (args[0] if args.size() > 0 else ".") + "\n"
	return CommandResult.new(output, CommandResult.TerminationStatus.EXIT_SUCCESS)

static func cowsay_bin(args: Array, is_pipe: bool, previous_command: CommandResult) -> CommandResult:
	if previous_command.termination_status == CommandResult.TerminationStatus.EXIT_FAILURE:
		return previous_command
	if len(args) == 0 and !is_pipe:
		return CommandResult.new("DSH: COWSAY: NO ARGUMENTS PROVIDED\n", CommandResult.TerminationStatus.EXIT_FAILURE)
	var from_echo: CommandResult
	if is_pipe:
		previous_command
		from_echo = echo_bin(previous_command.output.erase(previous_command.output.length() - 1, 1).split(" "), is_pipe, previous_command)
	else:
		from_echo = echo_bin(args, is_pipe, CommandResult.new("", CommandResult.TerminationStatus.EXIT_SUCCESS))
	
	return CommandResult.new(" " + "_".repeat(len(from_echo.output) + 1) +
	"\n< " + from_echo.output.erase(from_echo.output.length() - 1, 1) + " >" +
	"\n " + "_".repeat(len(from_echo.output) + 1) + "\n" +
	"    \\   ^__^\n" +
	"	 \\  (oo)\\_______\n" +
	"		(__)\\       )\\/\\\n" +
	"			||----w |\n" +
	"			||     ||\n", CommandResult.TerminationStatus.EXIT_SUCCESS)
