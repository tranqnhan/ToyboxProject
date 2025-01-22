extends Object
class_name Problem

var name: String
var success: int
var attempt: int
var answer: String

func _init(_name: String, _answer: String, _success: int, _attempt: int) -> void:
	name = _name
	success = _success
	attempt = _attempt
	answer = _answer

func attempt_success():
	attempt += 1
	success += 1

func attempt_failed():
	attempt += 1

func get_score() -> float:
	return success / attempt

func get_answer() -> String:
	return answer

func get_name() -> String:
	return name
