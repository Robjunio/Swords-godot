extends Node

var fsm: StateMachine

func enter():
	if fsm.controller.enemy_movement:
		fsm.controller.enemy_movement.can_move = true
	
	var hits = $Area2D.get_overlapping_bodies();
	for hit in hits:
		if hit.is_in_group("player"):
			print("Player Found")
			exit("AttackState")
			return;
	await get_tree().create_timer(0.2).timeout
	exit("FollowState")


func exit(next_state):
	fsm.change_to(next_state)


func _unhandled_key_input(event):
	if event.pressed:
		print("From State Follow")
