extends Camera2D

const CENTER_OFFSET = 7

var focus_pos: int = 4

func _ready() -> void:
	_update_position()

func _update_position():
	position.x = (focus_pos - CENTER_OFFSET) * 8


func update_focus(player_pos: int):
	var player_focus = player_pos + CENTER_OFFSET
	focus_pos = clamp(focus_pos, player_focus - 4, player_focus - 3)
	_update_position()
