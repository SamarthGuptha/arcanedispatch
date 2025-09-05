extends Area2D

@onready var request_indicator = $RequestIndicator

var has_active_request = false
var is_mouse_over = false # New variable to track mouse hover

func set_active_request(is_active):
	has_active_request = is_active
	request_indicator.visible = is_active

# This function is called when the mouse enters the collision shape.
func _on_mouse_entered():
	is_mouse_over = true

# This function is called when the mouse exits the collision shape.
func _on_mouse_exited():
	is_mouse_over = false

# A helper function for other scripts to check our status.
func is_mouse_hovering():
	return is_mouse_over
