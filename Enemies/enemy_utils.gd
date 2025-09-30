extends Node

signal bomb_enemy_exploded(pos: Vector2i)

func get_enemy_tiles() -> Dictionary[Vector2i, Entity]:
	var list: Dictionary[Vector2i, Entity] = {}
	for enemy in get_tree().get_nodes_in_group(&"Enemy"):
		list[enemy.tile_pos] = enemy
	return list 

#func explode_at(pos: Vector2i):
	#bomb_enemy_exploded
