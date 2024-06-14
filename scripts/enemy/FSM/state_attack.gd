extends Node

@export var attack_cooldown: float
@export var attack_damage: float
var sprite: Sprite2D
var animationPlayer: AnimationPlayer

var fsm: StateMachine

var is_attacking: bool = false
var cooldown: float = 0.0
var attack_dir: Vector2

func _ready():
	sprite = get_parent().get_parent().get_node("Sprite2D")
	animationPlayer = get_parent().get_parent().get_node("AnimationPlayer")

func enter():
	if(fsm.controller.enemy_movement):
		fsm.controller.enemy_movement.can_move = false
	
	if is_attacking:
		return
	else:
		# Getting hits
		var hits = $Area2D.get_overlapping_bodies()
		for hit in hits:
			if hit.is_in_group("player"):
				is_attacking = true
				cooldown = attack_cooldown
				var dir_to_enemy = hit.position - fsm.get_parent().position
				dir_to_enemy = dir_to_enemy.normalized()
				# Setting attack animation based on player dir
				var list_dir_dot: Array[Vector2] = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
				
				var best_dir: int
				var high_dot: float = -1
				
				for i in list_dir_dot.size():
					var dot = dir_to_enemy.dot(list_dir_dot[i])
					if dot >= high_dot:
						high_dot = dot
						best_dir = i
				
				if list_dir_dot[best_dir] == Vector2.UP:
					animationPlayer.play("attack_up")
				elif list_dir_dot[best_dir] == Vector2.DOWN:
					animationPlayer.play("attack_down")
				elif list_dir_dot[best_dir] == Vector2.RIGHT:
					sprite.flip_h = false
					animationPlayer.play("attack_side")
				elif list_dir_dot[best_dir] == Vector2.LEFT:
					sprite.flip_h = true
					animationPlayer.play("attack_side")
			
	# Exit 2 seconds later
	await get_tree().create_timer(2.0).timeout
	exit("FollowState")

func attack_hit():
	var hits = $Area2D.get_overlapping_bodies()
	for hit in hits:
		if hit.is_in_group("player"):
			var dir_to_enemy = hit.position - fsm.get_parent().position
			dir_to_enemy = dir_to_enemy.normalized()
			if sprite.flip_h:
				attack_dir = Vector2.LEFT
			else:
				attack_dir = Vector2.RIGHT
			
			var dot_product = dir_to_enemy.dot(attack_dir)
			if dot_product > 0.3:
				hit.damage(attack_damage)

func exit(next_state):
	fsm.change_to(next_state)


func _unhandled_key_input(event):
	if event.pressed:
		print("From State Idle")
