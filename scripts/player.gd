extends CharacterBody2D

@export var deadzone: float = 0.15
@export var speed: float = 300
@export var attack_cooldown: float = 0.6
@export var attack_damage: float = 3
@export var max_health: float
@export var death_prefab: PackedScene
@export var invulnerable_time: float


@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite_player: Sprite2D = %Sprite2D
@onready var sword_area: Area2D = $Area2D

var xp: float
var health: float
var cooldown: float = 0.0
var invulnerable_cooldown: float = 0.0
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var is_vulnerable: bool = true

var input_vector: Vector2 = Vector2.ZERO

func _ready() -> void:
	health = max_health
	
func get_xp(amount) -> void:
	xp += amount
	GameManager.player_xp = xp

func heal(amount) -> void:
	health += amount
	modulate = Color.GREEN_YELLOW
	var tween = create_tween().tween_property(self, "modulate", Color.WHITE, 0.3)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	
	if health > max_health:
		health = max_health

func damage(amount) -> void:
	if !is_vulnerable:
		return
	health -= amount
	modulate = Color.RED
	var tween = create_tween().tween_property(self, "modulate", Color.WHITE, 0.3)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	
	print("Player health: ", health)
	if health <= 0:
		die()
	else:
		is_vulnerable = false
		invulnerable_cooldown = invulnerable_time
		return

func die() -> void:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	GameManager.game_end = true
	GameManager.end_game()
	queue_free()

func read_input() -> void:
	# Getting input vector
	input_vector = Input.get_vector("move_left","move_right", "move_up", "move_down")
	
	# Aplicando o Deadzone
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0
	if abs(input_vector.y) < deadzone:
		input_vector.y = 0
		
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func animate_player() -> void:
	# Setting the animation
	if !is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("player_run")
			else:
				animation_player.play("player_idle")

func flip_player() -> void:
	# Fliping character
	if input_vector.x > 0:
		sprite_player.flip_h = false
	elif input_vector.x < 0:
		sprite_player.flip_h = true

func attack() -> void:
	if is_attacking:
		return
	
	animation_player.play("player_left_right_attack_1")
	
	cooldown = attack_cooldown
	
	is_attacking = true

func hit_enemy() -> void:
	var hits = sword_area.get_overlapping_bodies();
	for hit in hits:
		if hit.is_in_group("enemies"):
			var enemy = hit
			
			var dir_to_enemy = (enemy.position - position).normalized()
			var attack_dir: Vector2
			if sprite_player.flip_h:
				attack_dir = Vector2.LEFT
			else:
				attack_dir = Vector2.RIGHT
			
			var dot_product = dir_to_enemy.dot(attack_dir)
			if dot_product > 0.3:
				enemy.damage(attack_damage)

func update_attack_cooldown(delta: float) -> void:
	if is_attacking:
		cooldown -= delta
		if cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("player_idle")

func update_vulnerable_cooldown(delta: float) -> void:
	if !is_vulnerable:
		invulnerable_cooldown -= delta
		if invulnerable_cooldown <= 0.0:
			is_vulnerable = true

func _process(delta: float) -> void:
	GameManager.player_position = position
	
	read_input()
	
	update_vulnerable_cooldown(delta)
	# Processing attack cooldown
	update_attack_cooldown(delta)
	# Animate Character
	animate_player()
	# flip player character based on input direction
	if !is_attacking:
		flip_player()
	# Attack
	if Input.is_action_just_pressed("attack"):
		attack()

func _physics_process(delta: float) -> void:	
	# Aplica a velocidade desejada
	var target_velocity = input_vector * speed
	
	if target_velocity == Vector2.ZERO:
		velocity = Vector2.ZERO
	else:
		velocity = lerp(velocity, target_velocity, 0.05)
	
	if !is_attacking:
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		move_and_slide()
