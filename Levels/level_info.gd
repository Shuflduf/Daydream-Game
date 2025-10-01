class_name LevelInfo
extends Resource

@export var name: String
@export var unlocked: bool
var trophies_unlocked: int

func get_dict() -> Dictionary:
	return {
		"name": name,
		"unlocked": unlocked, 
		"trophies_unlocked": trophies_unlocked,
	}

static func from_dict(dict: Dictionary) -> LevelInfo:
	var new_level_info = LevelInfo.new()
	new_level_info.name = dict["name"]
	new_level_info.unlocked = dict["unlocked"]
	new_level_info.trophies_unlocked = dict["trophies_unlocked"]
	return new_level_info
