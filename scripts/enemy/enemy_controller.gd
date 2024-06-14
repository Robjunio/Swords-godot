class_name EnemyController

extends Node2D

@export var direction: Array[Vector2]
var context: ContextMap
var enemy_movement: EnemyMovement

func _ready():
	context = get_parent().get_node("ContextMap")
	enemy_movement = get_parent().get_node("EnemyMovement")

func get_dir_with_context(dir: Vector2) -> Vector2:
	var interest_vector: Array[float]
	for base_dir in direction:
		interest_vector.append(dir.dot(base_dir))
		
	var context_vector: Array[float]
	var best_dir: int
	var high_value = -5
	
	for i in direction.size():
		context_vector.append(interest_vector[i] - context.get_danger_array()[i])
		if high_value <= context_vector[i]:
			best_dir = i
			high_value = context_vector[i]
	
	return direction[best_dir]
