extends Node2D

signal moved(new_tile_pos: Vector2i)

var tile_pos: Vector2i
var prev_pos: Vector2i

const DIRS = {
	&"down": Vector2i(0, 1),
	&"up": Vector2i(0, -1),
	&"left": Vector2i(-1, 0),
	&"right": Vector2i(1, 0),
}
	

func _update_position():
	position = Vector2(tile_pos * 8)


func _unhandled_key_input(event: InputEvent) -> void:
	for dir in DIRS:
		if event.is_action_pressed(dir):
			prev_pos = tile_pos
			tile_pos += DIRS[dir]
			_update_position()
			moved.emit(tile_pos)
			if dir == &"left":
				$Sprite.flip_h = true
			elif dir == &"right":
				$Sprite.flip_h = false
			break


func cancel_move():
	tile_pos = prev_pos
	_update_position()
