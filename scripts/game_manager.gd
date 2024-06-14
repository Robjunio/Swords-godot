extends Node

var player_position: Vector2
var player_xp: float
var game_end: bool = false

var enemy_count: int
var enemies_kills: int = 0

func _enemy_die():
	enemy_count -= 1
	enemies_kills += 1

func _enemy_spawn():
	enemy_count += 1

func end_game():
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()

