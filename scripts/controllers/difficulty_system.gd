extends Node

var timer: float = 0.0
@export var mobs_increase_per_minute: float = 15
@export var spawner: mob_spawner

func _process(delta):
	timer += delta
	
	if mobs_increase_per_minute <= timer:
		spawner.enemy_max_quantity += 5
		timer = 0
