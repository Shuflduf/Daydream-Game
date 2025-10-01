extends Node

const SAVE_PATH = "rocks.json"

var levels_index: LevelSet = preload("res://Levels/levels_list.tres")
var current_level = 0

func _ready() -> void:
	load_progress()
	#print(levels_index.levels[0].name)

func get_current_level_info() -> LevelInfo:
	return levels_index.levels[current_level]
	
func unlock_next():
	if levels_index.levels.size() <= current_level + 1:
		return
	levels_index.levels[current_level + 1].unlocked = true
	save_progress()

func has_next_unlocked() -> bool:
	if levels_index.levels.size() <= current_level + 1:
		return false
	return levels_index.levels[current_level + 1].unlocked

func save_progress():
	var save_data = []
	for level in levels_index.levels:
		save_data.append(level.get_dict())
	var save_str = JSON.stringify(save_data)
	FileAccess.open(SAVE_PATH, FileAccess.WRITE).store_string(save_str)
	
func load_progress():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var save_str = FileAccess.get_file_as_string(SAVE_PATH)
	var save_data = JSON.parse_string(save_str)
	levels_index.levels = []
	for level_data in save_data:
		levels_index.levels.append(LevelInfo.from_dict(level_data))
