class_name UI
extends Control

@onready var energy: PanelContainer = %Energy
@onready var arrow: PanelContainer = %Arrow

func set_item(first: bool, id: StringName):
	var tile_pos: Vector2i
	if id.is_empty():
		tile_pos = Vector2i(3, 3)
	else:
		tile_pos = Interactables.ATLAS[id]
	var atlas_pos = Vector2(tile_pos * 8)
	var target_tex = %TexOne if first else %TexTwo
	target_tex.texture.region.position = atlas_pos

func set_tooltip(data: Dictionary[String, String]):
	%TooltipLabel.text = "{\n"
	for entry in data:
		%TooltipLabel.text += " "
		%TooltipLabel.text += entry
		%TooltipLabel.text += ":"
		%TooltipLabel.text += data[entry]
		%TooltipLabel.text += ",\n"
	%TooltipLabel.text += "}"


func _on_area_2d_mouse_entered() -> void:
	print("A")
