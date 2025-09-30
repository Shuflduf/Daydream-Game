@tool
extends Node

@onready var walls: Walls = $"../Walls"
@onready var interactable: Interactables = $"../Interactable"
@onready var enemies: Node2D = $"../Enemies"

@export var selected: LevelData
@export_tool_button("Save") var sis = save_into_selected
@export_tool_button("Load") var ls = load_selected


func save_into_selected():
	#print(selected.wall_data)
	selected.wall_data = walls.base.tile_map_data
	selected.interactable_data = interactable.tile_map_data
	selected.enemy_data = {}
	for enemy in enemies.get_children():
		selected.enemy_data[Vector2i(enemy.position / 8.0)] = enemy.id
	print(selected.enemy_data)
	
	
func load_selected():
	walls.base.tile_map_data = selected.wall_data
	walls.place_tiles()
	interactable.tile_map_data = selected.interactable_data
	for enemy in enemies.get_children():
		enemy.queue_free()
	for enemy_pos in selected.enemy_data:
		var id = selected.enemy_data[enemy_pos]
		var new_enemy = EnemyUtils.ENEMY_INDEX[id].instantiate()
		new_enemy.position = Vector2(enemy_pos * 8)
		enemies.add_child(new_enemy, true)
		new_enemy.owner = get_tree().edited_scene_root
		
