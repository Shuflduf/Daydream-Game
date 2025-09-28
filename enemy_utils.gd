extends Node

func get_enemy_tiles() -> Dictionary[Vector2i, Entity]:
	var list: Dictionary[Vector2i, Entity] = {}
	for enemy in get_tree().get_nodes_in_group(&"Enemy"):
		list[enemy.tile_pos] = enemy
	return list 
