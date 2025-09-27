extends Node2D


func _ready() -> void:
	generate_rock(Vector2i(8, 4), 8.3)


func generate_rock(offset: Vector2i, diameter: float):
	var radius = diameter / 2
	for x in ceili(diameter):
		var x_pos = x - radius
		for y in ceili(diameter):
			var y_pos = y - radius
			var dist_to_cent = sqrt((x_pos * x_pos) + (y_pos * y_pos))
			if dist_to_cent > radius:
				continue
			$Walls.tiles.append(Vector2i(int(x_pos) + offset.x, int(y_pos) + offset.y))
			$Walls.place_tiles()


func _on_player_moved(new_tile_pos: Vector2i) -> void:
	if new_tile_pos in $Walls.tiles:
		$Player.cancel_move()
		#$Walls.tiles.erase(new_tile_pos)
		$Walls.tiles = $Walls.tiles.filter(func(t): return t != new_tile_pos)
		$Walls.place_tiles()
