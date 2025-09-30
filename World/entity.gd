class_name Entity
extends Node2D

@onready var tile_pos: Vector2i = Vector2i(position / 8):
	set(value):
		tile_pos = value
		_update_position()


func _update_position():
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, ^"position", Vector2(tile_pos * 8), 0.1)
	#position = Vector2(tile_pos * 8)


func bump(dir: Vector2i):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, ^"position", position + Vector2(dir), 0.05)
	tween.tween_property(self, ^"position", position, 0.05)
	tween.tween_callback(_update_position)
