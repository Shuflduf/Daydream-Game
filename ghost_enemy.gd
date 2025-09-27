extends Node2D

@onready var health: Health = $Health
@onready var player = get_tree().get_first_node_in_group(&"Player")

var tile_pos = Vector2i(13, 2)
var can_move = true

func _update_position():
	position = Vector2(tile_pos * 8)

func cycle():
	if can_move:
		var target_vec = player.tile_pos - tile_pos
		if abs(target_vec.x) > abs(target_vec.y):
			tile_pos.x += signi(target_vec.x)
		else:
			tile_pos.y += signi(target_vec.y)
		_update_position()
		can_move = false
	else:
		can_move = true
