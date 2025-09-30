extends Control

func _ready() -> void:
	visible = LevelHandler.current_level == 0
