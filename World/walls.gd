@tool
class_name Walls
extends Node2D

@warning_ignore("unused_private_class_variable")
@export_tool_button("Outlines") var _go = _generate_outlines

var tiles: Array[Vector2i]


func _ready() -> void:
	tiles = $Base.get_used_cells()


#	reset()


func reset():
	tiles = []
	for tile in $Base.get_used_cells():
		$Base.erase_cell(tile)


func place_tiles():
	for tile in $Base.get_used_cells():
		$Base.erase_cell(tile)
	for tile in tiles:
		$Base.set_cell(tile, 0, Vector2i(1, 0))
	_generate_outlines()


func remove_at(pos: Vector2i):
	var index = tiles.find(pos)
	if index == -1:
		return
	tiles.remove_at(index)
	var new_particles = $BombParticles.duplicate()
	new_particles.position = Vector2(pos * 8) + Vector2(4.0, 4.0)
	add_child(new_particles)
	new_particles.restart()
	new_particles.finished.connect(func(): new_particles.queue_free())


func _generate_outlines():
	for tile in $Outline.get_used_cells():
		$Outline.erase_cell(tile)
	$Outline.set_cells_terrain_connect($Base.get_used_cells(), 0, 0)
