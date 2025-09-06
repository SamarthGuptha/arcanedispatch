extends Node
var delivery_timer = Timer.new()
var active_tower = null
var towers = []

var score = 0
var strikes = 0
var max_strikes = 3
var is_game_over = false

signal score_updated(new_score)
signal strikes_updated(new_strikes)
signal game_over

func _ready():
	score = 0
	strikes = 0
	is_game_over = false
	delivery_timer.wait_time = 5.7
	delivery_timer.one_shot = true
	delivery_timer.timeout.connect(create_new_request)
	add_child(delivery_timer)
	await get_tree().create_timer(0.1).timeout
	create_new_request()
func _on_delivery_timeout():
	if is_game_over: return
	
	if active_tower:
		active_tower.set_active_request(false)
	add_strike()
	if not is_game_over:
		create_new_request()

func create_new_request():
	if is_game_over:
		return
	towers = get_tree().get_nodes_in_group("towers")
	if towers.is_empty():
		return
	if active_tower != null:
		add_strike()
	if is_game_over:
		return
	towers.shuffle()
	active_tower = towers[0]
	active_tower.set_active_request(true)
	delivery_timer.start()
func complete_request(tower_node):
	if is_game_over:return false
	if tower_node == active_tower:
		delivery_timer.stop()
		score+=1
		score_updated.emit(score)
		active_tower.set_active_request(false)
		active_tower = null
		create_new_request()
		return true
	return false
func add_strike():
	if is_game_over: return
	strikes+=1
	strikes_updated.emit(strikes)
	if strikes>=max_strikes:
		is_game_over = true
		game_over.emit()
	
			
