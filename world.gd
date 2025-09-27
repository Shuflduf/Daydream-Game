extends Node2D



func cycle():
	$Interactable.cycle()


func _ready() -> void:
	generate_rock(Vector2i(8, 4), 8.3)


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
	cycle()
	if new_tile_pos in $Walls.tiles:
		$Player.cancel_move()
		#$Walls.tiles.erase(new_tile_pos)
		$Walls.tiles = $Walls.tiles.filter(func(t): return t != new_tile_pos)
		$Walls.place_tiles()
	elif new_tile_pos in $Interactable.tiles:
		$Player.cancel_move()
		$Interactable.interact(new_tile_pos)
	else:
		$Camera.update_focus(new_tile_pos.x)
	

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
			$Walls.tiles.erase(pos + Vector2i(x, y))
	$Walls.place_tiles()
