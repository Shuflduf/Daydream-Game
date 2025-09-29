extends Node2D

@onready var player: Node2D = $Player

func cycle():
	$Interactable.cycle()
	for enemy in get_tree().get_nodes_in_group(&"Enemy"):
		enemy.cycle()


func _ready() -> void:
	pass
	#generate_rock(Vector2i(8, 4), 8.3)


func generate_rock(offset: Vector2i, diameter: float):
	var placed: Array[Vector2i]
	var radius = diameter / 2
	for x in ceili(diameter):
		var x_pos = x - radius
		for y in ceili(diameter):
			var y_pos = y - radius
			var dist_to_cent = sqrt((x_pos * x_pos) + (y_pos * y_pos))
			if dist_to_cent > radius:
				continue
			var place_pos = Vector2i(int(x_pos) + offset.x, int(y_pos) + offset.y)
			if place_pos in placed:
				continue
			if randf() < 0.95:
				$Walls.tiles.append(place_pos)
			else:
				$Interactable.add_interactable(place_pos, &"bomb")
			placed.append(place_pos)
	$Walls.place_tiles()


func _on_player_moved(new_tile_pos: Vector2i) -> void:
	var enemies = EnemyUtils.get_enemy_tiles()
	if new_tile_pos in $Walls.tiles:
		#player.cancel_move()
		#$Walls.tiles.erase(new_tile_pos)
		#player.health.shift(-1)
		player.fake_move()
		$Walls.remove_at(new_tile_pos)
		#$Walls.tiles = $Walls.tiles.filter(func(t): return t != new_tile_pos)
		$Walls.place_tiles()
	elif new_tile_pos in $Interactable.tiles:
		#player.cancel_move()
		player.fake_move()
		$Interactable.interact(new_tile_pos)
	elif new_tile_pos in enemies:
		enemies[new_tile_pos].health.shift(-1)
		enemies[new_tile_pos].fake_move()
		player.fake_move()
		player.health.shift(-1)
	else:
		player.actually_move()
		$Camera.update_focus(new_tile_pos.x)
	cycle()
	

func get_collision_tiles() -> Array[Vector2i]:
	var all = []
	all.append_array($Walls.tiles)
	all.append_array($Interactable.tiles)
	return all


func _on_interactable_explode_bomb(pos: Vector2i) -> void:
	for x in range(-2, 3):
		for y in range(-2, 3):
			var length = sqrt((x*x)+(y*y))
			if length > 2:
				continue
			var target_pos = pos + Vector2i(x, y)
			#$Walls.tiles.erase(target_pos)
			$Walls.remove_at(target_pos)
			if player.tile_pos == target_pos:
				player.health.shift(-2)
	$Walls.place_tiles()


func _on_player_item_used(face_dir: Vector2i, id: StringName) -> void:
	var target_tile = player.tile_pos + face_dir
	match id:
		&"sword":
			var enemies = EnemyUtils.get_enemy_tiles()
			if enemies.has(target_tile):
				enemies[target_tile].health.shift(-3)
			elif target_tile in $Walls.tiles:
				$Walls.tiles = $Walls.tiles.filter(func(t): return t != target_tile)
				$Walls.place_tiles()
			else:
				# this might be fucking stupid
				player.health.shift(1)
			cycle()
		&"bomb":
			$Interactable.add_interactable(target_tile, id)
			$Interactable.trigger_bomb(target_tile)
