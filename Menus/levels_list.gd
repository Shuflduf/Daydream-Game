extends Control

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode >= KEY_0 and event.keycode <= KEY_9:
			var index = event.keycode - KEY_0 - 1
			if index < LevelHandler.levels_index.levels.size():
				if LevelHandler.levels_index.levels[index].unlocked:
					switch_to_level(index)
				else:
					$Failed.play()

func _ready() -> void:
	for i in LevelHandler.levels_index.levels.size():
		var level_info: LevelInfo = LevelHandler.levels_index.levels[i]
		#level_info.trophies_unlocked = 3
		var new_entry = %LevelBase.duplicate()
		%LevelsContainer.add_child(new_entry)
		new_entry.show()
		
		new_entry.label.text = str(i + 1)
		if level_info.unlocked:
			new_entry.gui_input.connect(_on_entry_gui_input.bind(i))
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
		
func _on_entry_gui_input(event: InputEvent, level_index: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		switch_to_level(level_index)
func switch_to_level(index: int):
	$Selected.play()
	await $Selected.finished
	LevelHandler.current_level = index
	get_tree().change_scene_to_file("res://HUD/interface.tscn")
