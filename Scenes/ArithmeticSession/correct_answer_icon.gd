extends Label

@export var appear_range_x: Vector2
@export var appear_range_y: Vector2
@export var appear_length: float
@export var appear_shift: Vector2


var current_tween: Tween


func _ready() -> void:
	visible = false
	set_process(false)
	

func _on_arithmetic_session_answer_result(is_correct: bool) -> void:
	if not is_correct:
		return
		
	if visible:
		current_tween.kill()
	
	var pos_x = randi_range(appear_range_x.x, appear_range_x.y)
	var pos_y = randi_range(appear_range_y.x, appear_range_y.y)
	position = Vector2(pos_x, pos_y)
	visible = true
	modulate = Color.WHITE
	current_tween = get_tree().create_tween()
	current_tween.parallel().tween_property(self, "modulate", Color("white", 0.0), appear_length)
	current_tween.parallel().tween_property(self, "position", position + appear_shift, appear_length)
	current_tween.finished.connect(func(): visible = false)
