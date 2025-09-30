extends Control

func _ready() -> void:
	for i in LevelHandler.levels_index.levels.size():
		var level_info: LevelInfo = LevelHandler.levels_index.levels[i]
		#level_info.trophies_unlocked = 3
		var new_entry = %LevelBase.duplicate()
		%LevelsContainer.add_child(new_entry)
		new_entry.show()
		new_entry.label.text = str(i + 1)
		if level_info.unlocked:
			new_entry.mouse_default_cursor_shape = CursorShape.CURSOR_POINTING_HAND
			for panel in new_entry.panels.get_children():
				panel.modulate = Color.WHITE
			if level_info.trophies_unlocked >= 3:
				new_entry.modulate = Color("6772a9")
			else:
				for trophy in level_info.trophies_unlocked:
					new_entry.panels.get_child(trophy).modulate = Color("6772a9")
		else:
			new_entry.modulate = Color("3a3277")
		
