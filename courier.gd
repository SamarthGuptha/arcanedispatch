extends PathFollow2D
const SPEED = 250.0
func _process(delta):
	set_progress(get_progress() + SPEED*delta)
	if get_progress_ratio() >=1.0:
		get_parent().queue_free()
