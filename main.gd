extends Node2D
@onready var path_drawer = $PathDrawer

var is_drawing = false
func _process(_delta):
	if is_drawing:
		var mouse_position = get_global_mouse_position()
		path_drawer.add_point(mouse_position)
		print("Adding point at: ", mouse_position, " | Total points: ", path_drawer.get_point_count())
func _input(event):
	if event.is_action_pressed("ui_accept"):
		is_drawing = true
		path_drawer.clear_points()
		print("Drawing STARTED")
	elif event.is_action_released("ui_accept"):
		is_drawing = false
		print("Drawing stopped")
