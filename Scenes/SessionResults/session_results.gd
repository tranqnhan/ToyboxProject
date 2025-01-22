extends Control


var coins_earned: int = 0
var num_correct_answers: int = 0
var num_incorrect_answers: int = 0 
var incorrect_problems: Array[String] = []
var main_theme: Theme = preload("res://Styles/main_theme.tres")
var last_practice_set: PracticeSet


func _ready() -> void:
	$MarginContainer/NavigationButtons.visible = false
	
	var total_coins_earned: Label = $HBoxContainer/CenterContainer1/VBoxContainer/TotalCoinsEarned
	var num_correct_ans: Label = $HBoxContainer/CenterContainer1/VBoxContainer/HBoxContainer/NumCorrectAnswers
	var num_incorrect_ans: Label = $HBoxContainer/CenterContainer1/VBoxContainer/HBoxContainer2/NumIncorrectAnswers
	var ca_tween: Tween = get_tree().create_tween()
	ca_tween.tween_method(update_to_label_number.bind(total_coins_earned), 0, coins_earned, 1.0)
	ca_tween.tween_method(update_to_label_number.bind(num_correct_ans), 0, num_correct_answers, 0.5)
	ca_tween.tween_method(update_to_label_number.bind(num_incorrect_ans), 0, num_incorrect_answers, 0.5)
		
		
	var track_incorrect_added: Dictionary = {}
	if num_incorrect_answers > 0:
		$HBoxContainer/CenterContainer2/IncorrectProblems/Label2.visible = true
		$HBoxContainer/CenterContainer2/IncorrectProblems/Label.visible = false
		ca_tween.tween_method(add_to_incorrect_problems.bind(track_incorrect_added), 0, len(incorrect_problems) - 1, 0.2 * num_incorrect_answers)
	
	ca_tween.finished.connect(func(): 
		$CelebrationAnimation.play_animation(num_correct_answers * 10)
		$MarginContainer/NavigationButtons.visible = true
		$MarginContainer/NavigationButtons.modulate = Color(0, 0, 0, 0)
		var t2: Tween = get_tree().create_tween()
		t2.tween_property($MarginContainer/NavigationButtons, "modulate", Color(1, 1, 1, 1), 2)
	)


func update_to_label_number(num: int, label: Label) -> void:
	label.text = str(num)


func add_to_incorrect_problems(i: int, tracker: Dictionary):
	if i < len(incorrect_problems):
		if tracker.has(i):
			return
			
		var l: Label = Label.new()
		l.text = incorrect_problems[i]
		$HBoxContainer/CenterContainer2/IncorrectProblems.add_child(l)
		l.theme = main_theme
		tracker[i] = true


func _on_again_button_pressed() -> void:
	get_tree().current_scene.queue_free()
	var arithmetic_session_scene = ResourceLoader.load("res://Scenes/ArithmeticSession/arithmetic_session.tscn")
	var arithmetic_session_scene_inst = arithmetic_session_scene.instantiate()
	arithmetic_session_scene_inst.practice_set = last_practice_set
	
	get_tree().root.add_child(arithmetic_session_scene_inst)
	# To make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = arithmetic_session_scene_inst


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/LessonMenu/lesson_menu.tscn")
