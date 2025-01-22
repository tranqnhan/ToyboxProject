extends Control

var main_theme: Theme = preload("res://Styles/main_theme.tres")

var addition_lessons: Array[PracticeSet] = []
var multiplication_lessons: Array[PracticeSet]
var subtraction_lessons: Array[PracticeSet]
var division_lessons: Array[PracticeSet]

var problem_group
var navigation_group

var selected_practice_set: PracticeSet

func _ready() -> void:
	
	problem_group = $MarginContainer/HBoxContainer/ProblemGroup/ScrollContainer/Problems
	navigation_group = $MarginContainer/HBoxContainer/ProblemGroup/NavigationButtons
	
	navigation_group.visible = false
	
	addition_lessons = []
	multiplication_lessons = []
	subtraction_lessons = []
	division_lessons = []
	
	for i in range(1, 6, 1):
		addition_lessons.append(AddBySet.new(i))
		
	for i in range(1, 6, 1):
		subtraction_lessons.append(SubtractBySet.new(i))
		
	for i in range(1, 6, 1):
		multiplication_lessons.append(MultiplyBySet.new(i))
	
	for i in range(1, 6, 1):
		division_lessons.append(DivideBySet.new(i))


func display_lessons(lesson: Array[PracticeSet]):
	for i in problem_group.get_children():
		i.queue_free()
		problem_group.remove_child(i)
		
	for i in lesson:
		var b: Button = Button.new()
		b.theme = main_theme
		b.text = i.set_name
		b.custom_minimum_size = Vector2(0, 75)
		problem_group.add_child(b)
		b.pressed.connect(display_problems_from_set.bind(i))
	
	navigation_group.visible = false

	
func display_problems_from_set(practice_set: PracticeSet):
	for i in problem_group.get_children():
		i.queue_free()
		problem_group.remove_child(i)
		
	for i in practice_set.get_problems():
		var l: Label = Label.new()
		l.theme = main_theme
		l.text = i.get_name() + i.get_answer()
		problem_group.add_child(l)
		
	selected_practice_set = practice_set
	navigation_group.visible = true


func _on_addition_button_pressed() -> void:
	display_lessons(addition_lessons)


func _on_subtraction_button_pressed() -> void:
	display_lessons(subtraction_lessons)


func _on_multiplication_button_pressed() -> void:
	display_lessons(multiplication_lessons)


func _on_division_button_pressed() -> void:
	display_lessons(division_lessons)


func _on_goto_lesson_pressed() -> void:
	if selected_practice_set == null:
		printerr("Go to lesson cannot be performed because selected_practice_set is null")
		return
	
	addition_lessons.clear()
	multiplication_lessons.clear()
	subtraction_lessons.clear()
	division_lessons.clear()

	
	get_tree().current_scene.queue_free()
	var arithmetic_session_scene = ResourceLoader.load("res://Scenes/ArithmeticSession/arithmetic_session.tscn")
	var arithmetic_session_scene_inst = arithmetic_session_scene.instantiate()
	arithmetic_session_scene_inst.practice_set = selected_practice_set
	
	get_tree().root.add_child(arithmetic_session_scene_inst)
	# To make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = arithmetic_session_scene_inst


func _on_goto_writing_pressed() -> void:
	if selected_practice_set == null:
		printerr("Go to lesson cannot be performed because selected_practice_set is null")
		return
	
	addition_lessons.clear()
	multiplication_lessons.clear()
	subtraction_lessons.clear()
	division_lessons.clear()
	
	get_tree().current_scene.queue_free()
	var trace_session_scene = ResourceLoader.load("res://Scenes/LetterTrace/trace_session.tscn")
	var trace_session_scene_inst = trace_session_scene.instantiate()
	trace_session_scene_inst.practice_set = selected_practice_set
	
	get_tree().root.add_child(trace_session_scene_inst)
	# To make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = trace_session_scene_inst
