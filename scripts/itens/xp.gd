extends Node

@export var xp_value: float = 10.0

func use_item(player: Node2D) -> void:
	player.get_xp(xp_value)
