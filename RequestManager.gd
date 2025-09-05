extends Node
var request_timer = Timer.new()
var active_tower = null
var towers = []

var score = 0
var strikes = 0
var max_strikes = 3

signal score_updated(new_score)
signal strikes_updated(new_strikes)
signal game_over

func _ready():
	request_timer.wait_time = 4.0
	request_timer.one_shot = false
	request_timer.timeout.connect(create_new_request)
	add_child(request_timer)
	request_timer.start()
	
	await get_tree().create_timer(0.1).timeout
	create_new_request()
func create_new_request():
	if active_tower != null:
		add_strike()
	towers = get_tree().get_nodes_in_group("towers")
	if towers.is_empty():
		return
	if active_tower:
		active_tower.set_active_request(false)
	towers.shuffle()
	active_tower = towers[0]
	active_tower.set_active_request(true)
func complete_request(tower_node):
	if tower_node == active_tower:
		score+=1
		score_updated.emit(score)
		active_tower.set_active_request(false)
		active_tower = null
		request_timer.start()
		return true
	return false
func add_strike():
	strikes+=1
	strikes_updated.emit(strikes)
	if strikes>=max_strikes:
		game_over.emit()
	
			
