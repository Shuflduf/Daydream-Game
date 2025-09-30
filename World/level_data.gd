@tool
class_name LevelData
extends Resource

@export var interactable_data: PackedByteArray = PackedByteArray()
@export var wall_data: PackedByteArray = PackedByteArray([5, 2])
@export var enemy_data: Dictionary[Vector2i, StringName]
