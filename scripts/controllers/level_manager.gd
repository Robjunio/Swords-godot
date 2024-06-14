extends ProgressBar

var level: int = 0
var xp_to_next_level: int = 0
var old_xp: int = 0
var level_up_count: int = 0
var current_xp: int = 0
@onready var level_label: Label = $level_label

func next_level_xp():
	var next_level = level + 1
	xp_to_next_level = 10 * pow(next_level, 2) * next_level/2 + 25
	min_value = 0
	max_value = xp_to_next_level
	level_label.text = "Level " + str(level)
	
func level_up():
	level_up_count += 1
	level += 1
	level_label.text = "Level " + str(level)
	next_level_xp()

func _ready():
	next_level_xp()

func _process(delta):
	var new_xp = (GameManager.player_xp - old_xp) + current_xp
	value = new_xp
	if new_xp >= xp_to_next_level:
		new_xp = new_xp - xp_to_next_level
		level_up()
		value = new_xp

		
		
