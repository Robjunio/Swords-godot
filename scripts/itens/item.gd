extends Node

var item_type: Node

func _ready():
	$Area2D.body_entered.connect(use_item)

func use_item(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Node.use_item(body)
		queue_free()
