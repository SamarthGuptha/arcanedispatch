extends Area2D
@onready var request_indicator = $RequestIndicator

var has_active_request = false

func set_active_request(active):
	has_active_request = active
	request_indicator.visible = active
