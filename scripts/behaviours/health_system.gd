extends CharacterBody2D

@export var max_health: float
@export var death_prefab: PackedScene
@onready var drop_system: Node = $DropSystem
var health: float

func _ready() -> void:
	health = max_health

func damage(amount) -> void:
	health -= amount
	modulate = Color.RED
	var tween = create_tween().tween_property(self, "modulate", Color.WHITE, 0.3)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	
	print("Enemy health: ", health)
	if health <= 0:
		die()
	else:
		return

func die() -> void:
	GameManager._enemy_die()
	drop_system.drop_itens()
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	queue_free()
