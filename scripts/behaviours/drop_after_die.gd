extends Node

@export var drop: PackedScene
@export var drop_rate: float

func drop_itens():
	if drop:
		# chances
		var odd = randf()
		if odd >= drop_rate:
			var drop_object = drop.instantiate()
			drop_object.position = get_parent().position
			get_parent().get_parent().add_child(drop_object)
			

