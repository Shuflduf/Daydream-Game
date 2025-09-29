extends Entity

@onready var health: Health = $Health
@onready var player = get_tree().get_first_node_in_group(&"Player")

var can_move = true
var enabled = false

func cycle():
	if not enabled:
		return
	var target_vec = player.tile_pos - tile_pos
	var wish_position = tile_pos
	if !target_vec.length() <= 1.0:
		if can_move:
			if target_vec.y != 0 and abs(target_vec.x) < 4:
				wish_position.y += signi(target_vec.y)
				can_move = false
			else:
				wish_position.x += signi(target_vec.x)
				can_move = false
		else:
			can_move = true
	if wish_position not in EnemyUtils.get_enemy_tiles():
		tile_pos = wish_position
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


func _on_screen_entered() -> void:
	enabled = true
