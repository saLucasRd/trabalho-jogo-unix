extends Node

class_name CommandResult

enum TerminationStatus {
	EXIT_SUCCESS,
	EXIT_FAILURE
}

var output: String
var termination_status: TerminationStatus
	
func _init(_output: String, _termination_status: TerminationStatus) -> void:
	self.output = _output
	self.termination_status = _termination_status
