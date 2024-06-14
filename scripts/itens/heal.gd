extends Node

@export var heal_value: float = 10.0

func use_item(player: Node2D) -> void:
	player.heal(heal_value)
