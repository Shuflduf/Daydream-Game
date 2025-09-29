extends Entity

@onready var health: Health = $Health
@onready var player = get_tree().get_first_node_in_group(&"Player")

var can_move = true

func cycle():
	var target_vec = player.tile_pos - tile_pos
	if !target_vec.length() <= 1.0:
		if can_move:
			if target_vec.y != 0 and abs(target_vec.x) < 4:
				tile_pos.y += signi(target_vec.y)
				can_move = false
			else:
				tile_pos.x += signi(target_vec.x)
				can_move = false
		else:
			can_move = true
	#if target_vec == Vector2i.ZERO:
		#player.cancel_move()
		#player.health.shift(-1)
		#health.shift(-1)
	#if can_move:
		#if target_vec.length() == 1.0:
			#pass
		#
	#else:
		#can_move = true
func fake_move():
	bump(-player.last_move)

func _on_health_die() -> void:
	queue_free()
