extends Node2D
var courier_scene = preload("res://Courier.tscn")

var is_drawing = false
var current_line = null
func _process(_delta):
	if is_drawing and current_line!=null:
		current_line.add_point(get_global_mouse_position())
func _input(event):
	if event.is_action_pressed("ui_accept"):
		is_drawing = true
		current_line = Line2D.new()
		current_line.width = 10.0
		current_line.default_color = Color.DARK_CYAN
		add_child(current_line)
		print("Drawing STARTED")
	elif event.is_action_released("ui_accept"):
		if is_drawing:
			is_drawing = false
			spawn_courier_on_path(current_line)
			current_line = null
func spawn_courier_on_path(line_node):
	var path_points = line_node.points
	if path_points.size()<2:
		line_node.queue_free()
		return
	var new_path = Path2D.new()
	new_path.curve = Curve2D.new()
	for point in path_points:
		new_path.curve.add_point(point)
	var courier = courier_scene.instantiate()
	line_node.get_parent().remove_child(line_node)
	new_path.add_child(line_node)
	new_path.add_child(courier)
	
	add_child(new_path)
	
