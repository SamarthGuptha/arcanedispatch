extends Area2D
signal path_draw_started
func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ui_accept"):
		path_draw_started.emit()
