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
"NÃO TEM \'MAN\', LEIA O LIVRO!\n", CommandResult.TerminationStatus.EXIT_FAILURE)

static func ls_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	var output: Array[String] = []
	var has_error = false

	if args.size() > 0:
		# Se argumentos são passados, listar conteúdos de diretórios especificados
		for arg in args:
			var dir_contents = vfs.list_dir(arg)
			if dir_contents:
				output.append(arg + ":\n" + "\n".join(dir_contents))
			else:
				output.append("DSH: LS: " + arg + ": NO SUCH FILE OR DIRECTORY")
				has_error = true
	else:
		# Listar o diretório atual se nenhum argumento for passado
		var current_dir_contents = vfs.list_current_dir()
		if current_dir_contents:
			output = current_dir_contents
		else:
			output.append("DSH: LS: FAILED TO LIST CURRENT DIRECTORY")
			has_error = true

	return CommandResult.new(
		"\n".join(output) + "\n",
		CommandResult.TerminationStatus.EXIT_FAILURE if has_error else CommandResult.TerminationStatus.EXIT_SUCCESS
	)

static func grep_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	# Verificar se o padrão foi especificado
	if args.size() == 0:
		return CommandResult.new("DSH: GREP: NO PATTERN SPECIFIED\n", CommandResult.TerminationStatus.EXIT_FAILURE)

	var pattern = args[0]
	var regex = RegEx.new()

	# Verificar se o padrão regex é válido
	if regex.compile(pattern) != OK:
		return CommandResult.new("DSH: GREP: INVALID REGEX PATTERN\n", CommandResult.TerminationStatus.EXIT_FAILURE)

	# Priorizar a entrada do pipe
	var source: String
	if is_pipe:
		source = previous_command.strip_edges()  # Garantir que o conteúdo do pipe está limpo
		if source == "":
			return CommandResult.new("DSH: GREP: NO DATA IN PIPE\n", CommandResult.TerminationStatus.EXIT_FAILURE)
	else:
		# Usar arquivo caso não haja pipe
		if args.size() < 2:
			return CommandResult.new("DSH: GREP: NO INPUT PROVIDED (PIPE OR FILE EXPECTED)\n", CommandResult.TerminationStatus.EXIT_FAILURE)
		source = vfs.read_from(args[1])
		if source == "":
			return CommandResult.new("DSH: GREP: FILE NOT FOUND OR EMPTY: " + args[1] + "\n", CommandResult.TerminationStatus.EXIT_FAILURE)

	# Aplicar o grep linha por linha
	var result: String = ""
	for line in source.split("\n"):
		if regex.search(line):
			result += line + "\n"

	# Retornar resultados ou mensagem de "nenhuma correspondência"
	if result.strip_edges() == "":
		return CommandResult.new("DSH: GREP: NO MATCHES FOUND\n", CommandResult.TerminationStatus.EXIT_FAILURE)

	return CommandResult.new(result, CommandResult.TerminationStatus.EXIT_SUCCESS)



static func echo_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	return CommandResult.new(" ".join(args) + "\n", CommandResult.TerminationStatus.EXIT_SUCCESS)

static func cut_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	if args.size() < 2:
		return CommandResult.new("DSH: CUT: INVALID ARGUMENTS\n", CommandResult.TerminationStatus.EXIT_FAILURE)
	var delimiter = args[0]
	var field = int(args[1]) - 1
	var source = previous_command if is_pipe else ""
	var result: Array[String] = []
	for line in source.split("\n"):
		var parts = line.split(delimiter)
		if field >= 0 and field < parts.size():
			result.append(parts[field])
	return CommandResult.new("\n".join(result) + "\n", CommandResult.TerminationStatus.EXIT_SUCCESS)

static func cd_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	if args.size() > 0:
		var dir = args[0]
		if vfs.navigate_to(dir):
			return CommandResult.new("", CommandResult.TerminationStatus.EXIT_SUCCESS)
		else:
			return CommandResult.new("DSH: CD: " + dir + ": NO SUCH FILE OR DIRECTORY\n", CommandResult.TerminationStatus.EXIT_FAILURE)
	else:
		vfs.navigate_to("/")
		return CommandResult.new("", CommandResult.TerminationStatus.EXIT_SUCCESS)

static func pwd_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	return CommandResult.new(vfs.pwd() + "\n", CommandResult.TerminationStatus.EXIT_SUCCESS)

static func cat_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	if args.size() == 0:
		return CommandResult.new("DSH: CAT: NO FILE SPECIFIED\n", CommandResult.TerminationStatus.EXIT_FAILURE)
	var result: String = ""
	for file in args:
		var content = vfs.read_from(file)
		if content == "":
			result += "DSH: CAT: FILE NOT FOUND OR IS A DIRECTORY: " + file + "\n"
		else:
			result += content
	return CommandResult.new(result, CommandResult.TerminationStatus.EXIT_SUCCESS)

static func sort_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	var source = previous_command if is_pipe else ""
	var sorted_lines = source.split("\n")
	sorted_lines.sort()
	return CommandResult.new("\n".join(sorted_lines) + "\n", CommandResult.TerminationStatus.EXIT_SUCCESS)

static func uniq_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	var source = previous_command if is_pipe else ""
	var lines = source.split("\n")
	var result: Array[String] = []
	var previous = ""
	for line in lines:
		if line != previous:
			result.append(line)
			previous = line
	return CommandResult.new("\n".join(result) + "\n", CommandResult.TerminationStatus.EXIT_SUCCESS)

static func xargs_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	if args.size() == 0:
		return CommandResult.new("DSH: XARGS: NO COMMAND PROVIDED\n", CommandResult.TerminationStatus.EXIT_FAILURE)
	if !is_pipe:
		return CommandResult.new("DSH: XARGS: NO INPUT PROVIDED VIA PIPE\n", CommandResult.TerminationStatus.EXIT_FAILURE)

	var command = args[0].to_upper()
	var command_args = args.slice(1)
	var inputs = previous_command.strip_edges().split("\n")

	if !bin_dict.has(command):
		return CommandResult.new("DSH: XARGS: COMMAND NOT FOUND: " + command + "\n", CommandResult.TerminationStatus.EXIT_FAILURE)

	var result_output = ""
	for input in inputs:
		var exec_args = command_args + [input]
		var result = bin_dict[command].call(exec_args, false, "")
		if result.termination_status != CommandResult.TerminationStatus.EXIT_SUCCESS:
			return result  # Retorna o erro do comando executado
		result_output += result.output

	return CommandResult.new(result_output, CommandResult.TerminationStatus.EXIT_SUCCESS)


static func cowsay_bin(args: Array, is_pipe: bool, previous_command: String) -> CommandResult:
	var message = previous_command if is_pipe else " ".join(args)
	if message.strip_edges() == "":
		return CommandResult.new("DSH: COWSAY: NO MESSAGE PROVIDED\n", CommandResult.TerminationStatus.EXIT_FAILURE)
	var bubble = " " + "_".repeat(message.length() + 2) + "\n"
	bubble += "< " + message + " >\n"
	bubble += " " + "-".repeat(message.length() + 2) + "\n"
	bubble += "    \\   ^__^\n"
	bubble += "     \\  (oo)\\______\n"
	bubble += "        (__)\\       )\\/\\\n"
	bubble += "            ||----w|\n"
	bubble += "            ||      ||\n"
	return CommandResult.new(bubble, CommandResult.TerminationStatus.EXIT_SUCCESS)
