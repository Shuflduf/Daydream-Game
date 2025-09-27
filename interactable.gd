class_name Interactables
extends TileMapLayer

signal explode_bomb(pos: Vector2i)

const ATLAS = {
	&"chest": Vector2i(2, 0),
	&"sword": Vector2i(3, 0),
	&"bomb": Vector2i(1, 2)
}

var bombs: Dictionary[Vector2i, int]
var tiles: Array[Vector2i]

func cycle():
	for bomb_pos in bombs:
		bombs[bomb_pos] -= 1
		var bomb_timer = bombs[bomb_pos]
		if bomb_timer <= 0:
			erase_cell(bomb_pos)
			tiles.erase(bomb_pos)
			explode_bomb.emit(bomb_pos)

func add_interactable(pos: Vector2i, id: StringName):
	tiles.append(pos)
	set_cell(pos, 0, ATLAS[id])

func interact(pos: Vector2i):
	var tile_id = get_cell_tile_data(pos).get_custom_data("id")
	#tiles.erase(pos)
	
	match tile_id:
		&"chest":
			set_cell(pos, 0, ATLAS[&"sword"])
		&"sword":
			erase_cell(pos)
			tiles.erase(pos)
		&"bomb":
			if not bombs.has(pos):
				bombs[pos] = 3
	print(tile_id)
