extends Control

func set_item(first: bool, id: StringName):
	var tile_pos: Vector2i
	if id.is_empty():
		tile_pos = Vector2i(3, 3)
	else:
		tile_pos = Interactables.ATLAS[id]
	var atlas_pos = Vector2(tile_pos * 8)
	var target_tex = %TexOne if first else %TexTwo
	target_tex.texture.region.position = atlas_pos
