extends Node
@export var attack_damage: float
@export var attack_cooldown: float
@export var attack_animation_time: float

var sprite: Sprite2D
var animation: AnimationPlayer
var body_2d: CharacterBody2D
var attack_area: Area2D

var cooldown: float = 0.0

var is_attacking: bool = false
var can_attack: bool = false

func attack() -> void:
	if is_attacking:
		return
	is_attacking = true
	cooldown = attack_cooldown
	animation.play("attack_side")

func attack_hit() -> void:
	var hits = attack_area.get_overlapping_bodies()
	for hit in hits:
		if hit.is_in_group("player"):
			var dir_to_enemy = hit.position - body_2d.position
			dir_to_enemy = dir_to_enemy.normalized()
			var attack_dir: Vector2
			if sprite.flip_h:
				attack_dir = Vector2.LEFT
			else:
				attack_dir = Vector2.RIGHT
			
			var dot_product = dir_to_enemy.dot(attack_dir)
			if dot_product > 0.3:
				hit.damage(attack_damage)

func _ready() -> void:
	body_2d = get_parent()
	sprite = body_2d.get_node("Sprite2D")
	attack_area = body_2d.get_node("AttackArea")
	animation = body_2d.get_node("AnimationPlayer")

func _physics_process(delta) -> void:
	if is_attacking:
		return
	var hits = attack_area.get_overlapping_bodies()
	for hit in hits:
		if hit.is_in_group("player"):
			attack()

func _process(delta):
	if is_attacking:
		cooldown -= delta
		if cooldown <= 0:
			is_attacking = false
		elif cooldown <= attack_cooldown - attack_animation_time:
			animation.play("run")

