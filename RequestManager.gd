extends Node
var request_timer = Timer.new()
var active_tower = null

func _ready():
	request_timer.wait_time = 4.0
	request_timer.one_shot = false
	request_timer.timeout.connect(create_new_request)
	add_child(request_timer)
	request_timer.start()
func create_new_request():
	if is_instance_valid(active_tower):
		active_tower.set_active_request(false)
		active_tower = null
	var all_towers = get_tree().get_nodes_in_group("towers")
	if all_towers.size()>0:
		all_towers.shuffle()
		active_tower = all_towers[0]
		active_tower.set_active_request(true)
func complete_request(tower_node):
	if tower_node == active_tower:
		active_tower.set_active_request(false)
		active_tower = null
		return true
	return false
	
	
			
