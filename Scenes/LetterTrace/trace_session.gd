extends Node

var problems: Array[Problem]
var max_problems_per_set: int

var main_theme: Theme = preload("res://Styles/main_theme.tres")

# INITIALIZE WITH PARAMETERS
var practice_set: PracticeSet = null


func _ready() -> void:
	#practice_set = MultiplyBySet.new(2)
	
	if practice_set == null:
		printerr("Parameters practice set must be set before scene initialization!")
		return

	problems = practice_set.get_problems().duplicate()
	max_problems_per_set = len(problems)
	$MarginContainer.visible = false
	display_letters_for_next_problem()


func get_next_problem() -> Problem:
	if len(problems) > 0:
		return problems.pop_front()
	else:
		return null


func display_letters_for_next_problem():
	var current_problem = get_next_problem()
	if current_problem == null:
		for p in practice_set.get_problems():
			var l = Label.new()
			l.text = p.name + p.answer
			l.theme = main_theme
			$MarginContainer/ProblemGroup/ScrollContainer/Problems.add_child(l)
		$MarginContainer.visible = true
		$MarginContainer.modulate = Color(1, 1, 1, 0)
		var tween: Tween = get_tree().create_tween()
		tween.tween_property($MarginContainer, "modulate", Color(1, 1, 1, 1), 1)
	else:
		$LetterTraceBox.generate_letters(current_problem.name + current_problem.answer)
		var t2: Tween = get_tree().create_tween()
		t2.tween_property($LetterTraceBox, "modulate", Color(1, 1, 1, 1), 1)


func _on_letter_trace_box_finished() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($LetterTraceBox, "modulate", Color(1, 1, 1, 0), 1)
	tween.finished.connect(func():
		display_letters_for_next_problem()
	)


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/LessonMenu/lesson_menu.tscn")
