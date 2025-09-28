class_name Entity
extends Node2D

@onready var tile_pos: Vector2i = Vector2i(position / 8):
	set(value):
		tile_pos = value
		_update_position()


func _update_position():
	position = Vector2(tile_pos * 8)
