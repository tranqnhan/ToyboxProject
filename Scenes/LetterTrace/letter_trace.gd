extends Control

@export var width = 0
@export var height = 185

var precision: int = 25
var current_segment: Array = []
var segments: Array = []
var current_point: int
var paths: Array[Node] = []
var path_num: int = 0
var activated: bool = false
var completed: bool = false

var real_position: Vector2
var path_break: Dictionary = {}


func _ready() -> void:
	custom_minimum_size = Vector2(width, height)
	for p in get_children():
		if p is Path2D:
			paths.append(p)
	set_process(false)
	$Label.modulate = Color($Label.modulate, 0.5)


func activate():
	activated = true
	$Label.modulate = Color($Label.modulate, 1)
	queue_redraw()


func next_segment():
	segments.append_array(current_segment)
	current_segment.clear()
	current_point += 1


func next_path():
	segments.append_array(current_segment)
	path_break[len(segments)] = null
	current_segment.clear()
	current_point = 0
	path_num += 1


func complete():
	segments.clear()
	current_segment.clear()
	for p in paths:
		p.queue_free()
	paths.clear()
	$Label.modulate = Color.GREEN


func _input(event:InputEvent):
	if not activated:
		return
		
	if Input.is_action_just_released("draw"):
		if current_point + 1 >= paths[path_num].curve.point_count:
			#valid, no erasure # next path num
			next_path()
			if path_num >= len(paths):
				complete()
				activated = false
		else:
			#current_point = max(0, current_point - 1)
			current_segment.clear()
		
		queue_redraw()
		return
		
	if Input.is_action_pressed("draw"):
		var closest_point: Vector2 = paths[path_num].curve.get_closest_point(event.position - real_position)
		var d: Vector2 = closest_point + real_position - event.position
		# within segment? -> draw
		if (d.length_squared() <= precision * precision):
			current_segment.append(event.position - real_position)
			
			# prevents from going backwards
			if current_point - 1 >= 0:
				var prev_checkpoint: Vector2 = paths[path_num].curve.get_point_position(current_point - 1)
				d = prev_checkpoint + real_position - event.position
				if d.length_squared() <= precision * precision:
					current_segment.clear()
					queue_redraw()
					return
				
			# if not last point
			if current_point + 1 < paths[path_num].curve.point_count:
				var checkpoint: Vector2 = paths[path_num].curve.get_point_position(current_point + 1)
				d = checkpoint + real_position - event.position
				# within next checkpoint? -> next segment
				if d.length_squared() <= precision * precision:
					var current_checkpoint: Vector2 = paths[path_num].curve.get_point_position(current_point)
					d = current_checkpoint - current_segment[0]
					# connected to the current checkpoint? -> next segment : clear
					if d.length_squared() <= precision * precision:
						next_segment()
					else:
						current_segment.clear()
		else:
			current_segment.clear()
		queue_redraw()
		return


func _draw():
	if not activated:
		return
		
	for p in range(1, len(segments)):
		if not (p in path_break):
			draw_line(segments[p-1], segments[p], Color.GREEN, 5.0)
		draw_circle(segments[p-1], 2.5, Color.GREEN)
		draw_circle(segments[p], 2.5, Color.GREEN)

	for p in range(1, len(current_segment)):
		draw_line(current_segment[p-1], current_segment[p], Color.GREEN, 5.0)
		draw_circle(current_segment[p-1], 2.5, Color.GREEN)
		draw_circle(current_segment[p], 2.5, Color.GREEN)
	
	if path_num < len(paths):
		for p in paths[path_num].curve.get_baked_points():
			draw_circle(p,1,Color.BLACK)
		
		draw_circle(paths[path_num].curve.get_point_position(min(current_point, paths[path_num].curve.point_count - 1)), 5.0, Color.BLUE)
		draw_circle(paths[path_num].curve.get_point_position(min(current_point + 1, paths[path_num].curve.point_count - 1)), 5.0, Color.RED)
