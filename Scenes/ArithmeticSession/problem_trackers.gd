extends Control

@export var problem_set_progress_tracker: PackedScene
@export var coin_particles: PackedScene

var next_tracker_id: int = 0
var tracker_group: HBoxContainer
var problem_to_tracker_map: Dictionary = {}
var current_tracker: int = 0
var redo: bool = false
var coin_particles_amount: int = 0

func _ready() -> void:
	tracker_group = $CenterContainer/HBoxContainer

var current_pointer_tween: Tween

func update_pointer_texture_position() -> void:
	if current_tracker >= tracker_group.get_child_count():
		$PointerTexture.visible = false
		return

	var t = tracker_group.get_children()[current_tracker]
	var ctx = t.global_position.x + t.size.x * tracker_group.scale.x / 2 - $PointerTexture.size.x / 2
	var cty = t.global_position.y + t.size.y * tracker_group.scale.y
	var new_pos: Vector2 = Vector2(ctx, cty)
	if next_tracker_id - 1 == 0:
		$PointerTexture.position = new_pos
		return
	
	if current_pointer_tween != null and current_pointer_tween.is_running():
		current_pointer_tween.kill()
	
	current_pointer_tween = get_tree().create_tween()
	
	if $PointerTexture.position.x == new_pos.x:
		current_pointer_tween.tween_property($PointerTexture, "rotation", 2*PI, 0.5)
		current_pointer_tween.finished.connect(func(): $PointerTexture.rotation = 0)
		return
	
	if $PointerTexture.position.x < new_pos.x:
		current_pointer_tween.tween_property($PointerTexture, "rotation", PI / 4, 0.2).set_trans(Tween.TRANS_QUAD)
	
	if $PointerTexture.position.x > new_pos.x:
		current_pointer_tween.tween_property($PointerTexture, "rotation", -PI / 4, 0.2).set_trans(Tween.TRANS_QUAD)
	
	current_pointer_tween.tween_property($PointerTexture, "position", new_pos, 0.5).set_trans(Tween.TRANS_QUAD)
	current_pointer_tween.tween_property($PointerTexture, "rotation", 0, 0.2).set_trans(Tween.TRANS_QUAD)


func _on_arithmetic_session_answer_result(is_correct: bool) -> void:
	var indicator = tracker_group.get_children()[current_tracker]
	if is_correct and not redo:
		indicator.modulate = Color.GREEN
		var coin_particles_inst: CPUParticles2D = coin_particles.instantiate()
		coin_particles_inst.position = indicator.global_position + indicator.size * indicator.scale / 2
		coin_particles_inst.emitting = true
		coin_particles_inst.amount = coin_particles_amount
		add_child(coin_particles_inst)
		coin_particles_inst.finished.connect((func(c): c.queue_free()).bind(coin_particles_inst))
		
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(indicator, "scale", Vector2.ONE * 0.5, 0.1)
		tween.tween_property(indicator, "scale", Vector2.ONE * 1.25, 0.2)
		tween.tween_property(indicator, "scale", Vector2.ONE * 1, 0.1)
		return
	
	if is_correct and redo:
		indicator.modulate = Color.BLUE_VIOLET
	else:
		indicator.modulate = Color.RED
		

func _on_arithmetic_session_init_problems(num_problems: int, coins_per_correct_answer: int) -> void:
	var indicator = null
	for i in range(num_problems):
		indicator = problem_set_progress_tracker.instantiate()
		tracker_group.add_child(indicator)
	coin_particles_amount = coins_per_correct_answer

func _on_h_box_container_sort_children() -> void:
	update_pointer_texture_position()


func _on_arithmetic_session_problem_changed(_new_problem: Problem, problem_session_id: int) -> void:
	if problem_to_tracker_map.has(problem_session_id):
		current_tracker = problem_to_tracker_map[problem_session_id]
		redo = true
	else:
		if next_tracker_id >= tracker_group.get_child_count():
			printerr("Too many problems for trackers")
		else:
			problem_to_tracker_map[problem_session_id] = next_tracker_id
			current_tracker = next_tracker_id
			
		next_tracker_id += 1
		
	update_pointer_texture_position()
