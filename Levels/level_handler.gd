extends Node

var levels_index = preload("res://Levels/levels_list.tres")
var current_level = 0

func _ready() -> void:
	print(levels_index.levels[0].name)

func get_current_level_info() -> LevelInfo:
	return levels_index.levels[current_level]
	
func unlock_next():
	if levels_index.levels.size() <= current_level + 1:
		return
	levels_index.levels[current_level + 1].unlocked = true

func has_next_unlocked() -> bool:
	if levels_index.levels.size() <= current_level + 1:
		return false
	return levels_index.levels[current_level + 1].unlocked
