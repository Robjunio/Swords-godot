extends Sprite2D

func _ready():
	var tween = create_tween().tween_property(self, "modulate", Color.SALMON, 0.8)
	tween.finished.connect(end_marker)

func end_marker():
	queue_free()
