extends Control

signal answer_result(is_correct: bool)
signal problem_changed(new_problem: Problem, problem_session_id: int)
signal user_answer_changed(answer: String)
signal init_problems(num_problems: int, coins_per_correct_answer: int)

@export var coins_per_correct_answer: int

var max_problems_per_set: int
var problems: Array[Problem] = []
var current_problem: Problem = null
var current_problem_session_id: int = 0
var num_correct_answers: int = 0
var user_answer: String = ""
var problems_for_session: Array[Problem] = []
var problems_session_ids: Array[int] = []
var count_total_attempts: int = 0
var incorrect_problems: Array[Problem] = []

# INITIALIZE WITH PARAMETERS
var practice_set: PracticeSet = null

func _ready() -> void:
	if practice_set == null:
		printerr("Parameters practice set must be set before scene initialization!")
		return
	
	problems = practice_set.get_problems()
	max_problems_per_set = len(problems)
	init_problems.emit(max_problems_per_set, coins_per_correct_answer)
	for i in range(max_problems_per_set):
		problems_session_ids.append(i)
		#problems_for_session.append(problems[randi_range(0, len(problems) - 1)])
		problems_for_session.append(problems[i])
	
	$External/LetterTraceBox.set_process(false)
	$External/LetterTraceBox.visible = false
	
	get_next_problem()
	

func change_user_answer(new_answer: String) -> void:
	user_answer = new_answer
	user_answer_changed.emit(user_answer)


func get_next_problem() -> void:
	if len(problems_for_session) > 0:
		current_problem = problems_for_session.pop_front()
		current_problem_session_id = problems_session_ids.pop_front()
		change_user_answer("")
		problem_changed.emit(current_problem, current_problem_session_id)
	else:
		current_problem = null


func _on_numpad_number_pressed(num: int) -> void:
	change_user_answer(user_answer + str(num))


func _on_numpad_delete_pressed() -> void:
	change_user_answer(user_answer.substr(0, len(user_answer) - 1))


func _on_numpad_enter_pressed() -> void:
	if current_problem == null or user_answer == "":
		return

	if current_problem.get_answer() == str(int(user_answer)):
		# Answer is correct
		answer_result.emit(true)
		if count_total_attempts < max_problems_per_set:
			num_correct_answers += 1
		get_next_problem()
	else:
		# Answer is incorrect
		answer_result.emit(false)
		problems_for_session.push_back(current_problem)
		problems_session_ids.push_back(current_problem_session_id)
		if count_total_attempts < max_problems_per_set:
			incorrect_problems.append(current_problem)
			
		# get_next_problem()
		# $VBoxContainer/HBoxContainer/AnswerBox.text = ""
		# set_new_problem()
	count_total_attempts += 1
	# Changes scene
	if current_problem == null:
		#$CelebrationAnimation/CPUParticles2D1.amount = coins_per_correct_answer / 2 * num_correct_answers
		#$CelebrationAnimation/CPUParticles2D2.amount = coins_per_correct_answer / 2 * num_correct_answers
		#$CelebrationAnimation/ConfettiAnimation.current_animation = "particles"
		#$WorkGroup/ProblemGroup/AnswerBox.text = ""
		#$WorkGroup/ProblemGroup/Question.text = "Congratulations!"
		session_to_results.call_deferred()
		
		return


func session_to_results() -> void:
	get_tree().current_scene.queue_free()
	var session_results_scene = ResourceLoader.load("res://Scenes/SessionResults/session_results.tscn")
	var session_results_scene_inst = session_results_scene.instantiate()
	session_results_scene_inst.coins_earned = coins_per_correct_answer * num_correct_answers
	session_results_scene_inst.num_correct_answers = num_correct_answers
	session_results_scene_inst.num_incorrect_answers = max_problems_per_set - num_correct_answers
	session_results_scene_inst.last_practice_set = practice_set
	for p in incorrect_problems:
		session_results_scene_inst.incorrect_problems.append(p.name + p.answer)
	
	get_tree().root.add_child(session_results_scene_inst)
	# To make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = session_results_scene_inst


func _on_goto_practice_pressed() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 0.5)
	$External/LetterTraceBox.generate_letters(current_problem.name + current_problem.answer)
	$External/LetterTraceBox.modulate = Color(0, 0, 0, 0)
	$External/LetterTraceBox.visible = true
	tween.tween_property($External/LetterTraceBox, "modulate", Color(1, 1, 1, 1), 0.5)
	tween.finished.connect(func():
		visible = false
		$External/LetterTraceBox.set_process(true)
	)


func _on_letter_trace_box_finished() -> void:
	var tween: Tween = get_tree().create_tween()
	visible = true
	$External/LetterTraceBox.set_process(false)
	$WorkGroup/IncorrectGroup.visible = false
	get_next_problem()
	self.modulate = Color(0, 0, 0, 0)
	tween.tween_property($External/LetterTraceBox, "modulate", Color(0, 0, 0, 0), 0.5)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5)
	tween.finished.connect(func(): 
		$WorkGroup/Numpad.visible = true
		$External/LetterTraceBox.visible = false
	)
