extends VBoxContainer


var correct_answer: String = ""


func _ready() -> void:
	$ProblemGroup.visible = true
	$IncorrectGroup.visible = false


func _on_arithmetic_session_problem_changed(new_problem: Problem, _problem_session_id: int) -> void:
	$ProblemGroup/Question.text = new_problem.get_name()
	$ProblemGroup/AnswerBox.text = ""
	correct_answer = new_problem.get_answer()


func _on_arithmetic_session_answer_result(is_correct: bool) -> void:
	if not is_correct:
		$IncorrectGroup.visible = true
		$Numpad.visible = false
		$IncorrectGroup/CorrectAnswer.text = $ProblemGroup/Question.text + correct_answer


func _on_arithmetic_session_user_answer_changed(answer: String) -> void:
	if len(answer) > len($ProblemGroup/AnswerBox.text):
		var tween = get_tree().create_tween()	
		tween.tween_property($ProblemGroup/AnswerBox, "scale", Vector2(1, 1.2), 0.15).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property($ProblemGroup/AnswerBox, "scale", Vector2(1, 1), 0.4).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	$ProblemGroup/AnswerBox.text = answer
