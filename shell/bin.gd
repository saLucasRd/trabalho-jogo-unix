extends Node

static var level_path := "res://level/"
static var vfs: VirtualFileSystem = VirtualFileSystem.new(level_path)

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

static func man_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	return CommandResult.new(
"LEIA O LIVRO!\n", CommandResult.TerminationStatus.EXIT_SUCCESS)

static func ls_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	var output: Array[String]
	output = vfs.list_current_dir()
	return CommandResult.new("\n".join(output) + "\n", CommandResult.TerminationStatus.EXIT_SUCCESS)
	
static func grep_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	# Simulação do comando LS
	var output = "FILES: " + (args[0] if args.size() > 0 else ".") + "\n"
	return CommandResult.new(output, CommandResult.TerminationStatus.EXIT_SUCCESS)


static func echo_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	var a = PackedStringArray(args)
	var output = " ".join(a) + "\n"
	return CommandResult.new(output, CommandResult.TerminationStatus.EXIT_SUCCESS)

static func cut_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	# Simulação do comando ECHO
	var a = PackedStringArray(args)
	var output = " ".join(a) + "\n"
	return CommandResult.new(output, CommandResult.TerminationStatus.EXIT_SUCCESS)

static func cd_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	# Simulação do comando CD
	
	if args.size() > 0:
		var dir = args[0]
		var pwd := vfs.navigate_to(dir)
		if pwd:
			return CommandResult.new("", CommandResult.TerminationStatus.EXIT_SUCCESS)
		else:
			return CommandResult.new("DSH: CD: " + dir + ": NO SUCH FILE OR DIRECTORY\n", CommandResult.TerminationStatus.EXIT_FAILURE)
	else:
		vfs.navigate_to("/")
		return CommandResult.new("", CommandResult.TerminationStatus.EXIT_SUCCESS)


static func pwd_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	return CommandResult.new(vfs.current_dir_string + "\n", CommandResult.TerminationStatus.EXIT_SUCCESS)

static func cat_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	if args.size() > 0:
		var output = "CONTEÚDO DO ARQUIVO " + args[0] + "\nEXEMPLO DE TEXTO NO ARQUIVO.\n"
		return CommandResult.new(output, CommandResult.TerminationStatus.EXIT_SUCCESS)
	else:
		return CommandResult.new("ERRO: NENHUM ARQUIVO ESPECIFICADO.\n", CommandResult.TerminationStatus.EXIT_FAILURE)

static func sort_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	# Simulação do comando LS
	var output = "FILES: " + (args[0] if args.size() > 0 else ".") + "\n"
	return CommandResult.new(output, CommandResult.TerminationStatus.EXIT_SUCCESS)

static func uniq_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	# Simulação do comando LS
	var output = "FILES: " + (args[0] if args.size() > 0 else ".") + "\n"
	return CommandResult.new(output, CommandResult.TerminationStatus.EXIT_SUCCESS)

static func xargs_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	# Simulação do comando LS
	var output = "FILES: " + (args[0] if args.size() > 0 else ".") + "\n"
	return CommandResult.new(output, CommandResult.TerminationStatus.EXIT_SUCCESS)

static func cowsay_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	if len(args) == 0 and !is_pipe:
		return CommandResult.new("DSH: COWSAY: NO ARGUMENTS PROVIDED\n", CommandResult.TerminationStatus.EXIT_FAILURE)
	var from_echo: CommandResult
	if is_pipe:
		previous_command
		from_echo = echo_bin(previous_command.erase(previous_command.length() - 1, 1).split(" "), false, previous_command)
	else:
		from_echo = echo_bin(args, is_pipe, "")
	
	return CommandResult.new(" " + "_".repeat(len(from_echo.output) + 1) +
	"\n< " + from_echo.output.erase(from_echo.output.length() - 1, 1) + " >" +
	"\n " + "_".repeat(len(from_echo.output) + 1) + "\n" +
	"    \\   ^__^\n" +
	"	 \\  (oo)\\_________\n" +
	"		(__)\\       )\\/\\\n" +
	"			||----w |\n" +
	"			||     ||\n", CommandResult.TerminationStatus.EXIT_SUCCESS)
