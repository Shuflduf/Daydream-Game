extends Enemy

var can_move = true


func _ready() -> void:
	super()
	tooltip.data["name"] = "Bob"


func fake_move():
	if player.last_move == Vector2i(-1, 0):
		explode()
	else:
		bump(-player.last_move)


func cycle():
	if can_move:
		var target_pos = tile_pos - Vector2i(1, 0)
		if target_pos == player.tile_pos:
			explode()
		else:
			map_tiles_requested.emit()
			if target_pos in map_tiles:
				explode()
			else:
				tile_pos.x -= 1
				can_move = false
	else:
		can_move = true


func explode():
	EnemyUtils.bomb_enemy_exploded.emit(tile_pos)
	queue_free()


func _on_health_die() -> void:
	queue_free()
	tooltip.remove()
	EnemyUtils.interactable_added.emit(tile_pos, &"bomb")
