extends CanvasLayer
@onready var score_label = $HBoxContainer/ScoreLabel
@onready var strikes_container = $HBoxContainer/StrikesContainer

func _ready():
	RequestManager.score_updated.connect(update_score)
	RequestManager.strikes_updated.connect(update_strikes)
	
	update_score(RequestManager.score)
	update_strikes(RequestManager.strikes)
func update_score(new_score):
	score_label.text = "Score: " + str(new_score)
func update_strikes(new_strikes):
	for child in strikes_container.get_children():
		child.queue_free()
		
	for i in range(new_strikes):
		var strike_icon = Label.new()
		strike_icon.text = "X"
		strikes_container.add_child(strike_icon)
