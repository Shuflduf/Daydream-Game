extends Enemy

var can_move = true

func _ready() -> void:
	super()
	tooltip.data["name"] = "Gast"

func cycle():
	if not enabled:
		return
	var target_vec = player.tile_pos - tile_pos
	var wish_position = tile_pos
	if !target_vec.length() <= 1.0:
		if can_move:
			$Sprite.flip_h = signi(target_vec.x) == 1
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
