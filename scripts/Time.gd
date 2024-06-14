extends Label

var time_elapsed = 0

func _process(delta):
	if GameManager.game_end:
		return
	
	time_elapsed += delta
	var time_elapsed_in_seconds: int = floori(time_elapsed)
	var seconds: int = time_elapsed_in_seconds % 60
	var minutes: int = time_elapsed_in_seconds / 60
	text = "%02d:%02d" % [minutes, seconds]
	
