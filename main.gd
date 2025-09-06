extends Node2D

var courier_scene = preload("res://courier.tscn")
@onready var depot = $Depot

var is_drawing = false
var current_line = null

func _ready():
	depot.path_draw_started.connect(_on_depot_path_draw_started)

func _process(delta):
	if is_drawing and current_line != null:
		current_line.add_point(get_global_mouse_position())

func _input(event):
	if event.is_action_released("ui_accept"):
		if is_drawing:
			is_drawing = false
			handle_path_finished()

func _on_depot_path_draw_started():
	is_drawing = true
	current_line = Line2D.new()
	current_line.width = 10.0
	current_line.default_color = Color.WHITE
	current_line.add_point(depot.global_position)
	add_child(current_line)

func handle_path_finished():
	print("--- Handling Path Finish (New Method) ---")
	
	var target_tower = null
	# Iterate through all towers to find which one is under the mouse
	for tower in get_tree().get_nodes_in_group("towers"):
		if tower.is_mouse_hovering():
			target_tower = tower
			print("SUCCESS: Mouse is over '", tower.name, "'. Setting as target.")
			break # Found our tower, no need to check others
	
	if target_tower and RequestManager.complete_request(target_tower):
		print("DELIVERY SUCCESS: Spawning courier.")
		spawn_courier_on_path(current_line)
	else:
		if not target_tower:
			print("DELIVERY FAILED: Mouse was not released over any valid tower.")
		else:
			print("DELIVERY FAILED: '", target_tower.name, "' was not the correct tower for the active request.")
		
		if current_line:
			print("Deleting the drawn line.")
			current_line.queue_free()
			
	current_line = null
	print("--------------------------\n")

func spawn_courier_on_path(line_node):
	if line_node == null or line_node.points.size() < 2:
		if line_node != null:
			line_node.queue_free()
		return

	var new_path = Path2D.new()
	new_path.curve = Curve2D.new()
	for point in line_node.points:
		new_path.curve.add_point(point)

	var courier = courier_scene.instantiate()
	
	if line_node.get_parent():
		line_node.get_parent().remove_child(line_node)
	new_path.add_child(line_node)
	
	new_path.add_child(courier)
	add_child(new_path)
