class_name EnemyMovement

extends Node

var sprite: Sprite2D
var enemy: CharacterBody2D
var animator: AnimationPlayer
var enemy_controller: EnemyController

var can_move: bool = false
@export var speed: float = 1

var dir: Vector2

func _ready() -> void:
	enemy = get_parent()
	enemy_controller = enemy.get_node("EnemyController")
	sprite = enemy.get_node("Sprite2D")
	animator = enemy.get_node("AnimationPlayer")

func flip_character() -> void:
	# Fliping character
	if dir.x > 0:
		sprite.flip_h = false
	elif dir.x < 0:
		sprite.flip_h = true

func _physics_process(delta) -> void:
	if !can_move:
		return
	
	var player_position = GameManager.player_position
	var diference = player_position - enemy.position
	dir = diference.normalized()
	
	dir = enemy_controller.get_dir_with_context(dir)
	var target_velocity = dir * speed * 100
	var steering_velocity = target_velocity - enemy.velocity
	steering_velocity = steering_velocity * 10
	
	flip_character()
	
	enemy.velocity = enemy.velocity + (steering_velocity * delta)
	enemy.move_and_slide()
