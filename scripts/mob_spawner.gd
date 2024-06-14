class_name mob_spawner

extends Marker2D

@export var enemies: Array[PackedScene]
@export var marker: PackedScene
@onready var area: ReferenceRect = $ReferenceRect
@export var enemy_max_quantity: float = 5
@export var spawn_cooldown: float = 0.5

var cooldown: float = 0

func spawn_barrel():
	var end_position = area.get_rect().position + Vector2(randf() * area.size.x, randf() * area.size.y)
	
	var point = end_position
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask =  0b10
	var result = world_state.intersect_point(parameters, 1)
	if result.is_empty(): return
	
	var marker_object = marker.instantiate()
	add_child(marker_object)
	marker_object.position = end_position
	
	GameManager._enemy_spawn()
	await get_tree().create_timer(0.6).timeout
	
	var enemy_object = enemies[0].instantiate()
	add_child(enemy_object)
	enemy_object.position = end_position
	

func _process(delta):
	if GameManager.game_end:
		return
		
	cooldown -= delta
	
	if GameManager.enemy_count >= enemy_max_quantity:
		return
		
	if cooldown <= 0:
		spawn_barrel()
