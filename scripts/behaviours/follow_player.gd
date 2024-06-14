extends Node

var sprite: Sprite2D
var enemy: CharacterBody2D
var animator: AnimationPlayer

@export var max_dist_from_player: float = 1.5
@export var speed: float = 100

var dir: Vector2

func _ready() -> void:
	enemy = get_parent()
	sprite = enemy.get_node("Sprite2D")
	animator = enemy.get_node("AnimationPlayer")

func flip_character() -> void:
	# Fliping character
	if dir.x > 0:
		sprite.flip_h = false
	elif dir.x < 0:
		sprite.flip_h = true

func distance(vec1: Vector2, vec2: Vector2) -> float:
	var dist = sqrt(pow(vec2.x - vec1.x, 2) + pow(vec2.y - vec1.y, 2))
	return dist

func _physics_process(delta) -> void:
	if animator.current_animation == "attack_side":
		return
	var player_position = GameManager.player_position
	var dist = distance(enemy.position, player_position)
	var diference = player_position - enemy.position
	dir = diference.normalized()
	var target_velocity = dir * speed * 100
	
	flip_character()
	enemy.velocity = lerp(enemy.velocity, target_velocity, 0.05)
	enemy.move_and_slide()
