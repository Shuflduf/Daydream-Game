@tool
class_name Walls
extends Node2D

@warning_ignore("unused_private_class_variable")
@export_tool_button("Outlines") var _go = _generate_outlines

var tiles: Array[Vector2i]

func _ready() -> void:
	tiles = []
	for tile in $Base.get_used_cells():
		$Base.erase_cell(tile)


func place_tiles():
	for tile in $Base.get_used_cells():
		$Base.erase_cell(tile)
	for tile in tiles:
		$Base.set_cell(tile, 0, Vector2i(1, 0))
	_generate_outlines()


func _generate_outlines():
	for tile in $Outline.get_used_cells():
		$Outline.erase_cell(tile)
	$Outline.set_cells_terrain_connect($Base.get_used_cells(), 0, 0)
