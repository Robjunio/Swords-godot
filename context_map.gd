class_name ContextMap

extends Node

@onready var ray_up: RayCast2D = %up
@onready var ray_up_right: RayCast2D = %up_right
@onready var ray_up_left: RayCast2D = %up_left
@onready var ray_down: RayCast2D = %down
@onready var ray_down_right: RayCast2D = %down_right
@onready var ray_down_left: RayCast2D = %down_left
@onready var ray_right: RayCast2D = %right
@onready var ray_left: RayCast2D = %left

func get_danger_array() -> Array:
	var danger_array = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
	
	if(ray_up.is_colliding()):
		danger_array[0] += 5
		danger_array[7] += 2
		danger_array[1] += 2
	if(ray_up_right.is_colliding()):
		danger_array[1] += 5
		danger_array[2] += 2
		danger_array[0] += 2
	if(ray_right.is_colliding()):
		danger_array[2] += 5
		danger_array[3] += 2
		danger_array[1] += 2
	if(ray_down_right.is_colliding()):
		danger_array[3] += 5
		danger_array[4] += 2
		danger_array[2] += 2
	if(ray_down.is_colliding()):
		danger_array[4] += 5
		danger_array[5] += 2
		danger_array[3] += 2
	if(ray_down_left.is_colliding()):
		danger_array[5] += 5
		danger_array[6] += 2
		danger_array[4] += 2
	if(ray_left.is_colliding()):
		danger_array[6] += 5
		danger_array[7] += 2
		danger_array[5] += 2
	if(ray_up_left.is_colliding()):
		danger_array[7] += 5
		danger_array[0] += 2
		danger_array[6] += 2
	
	return danger_array
