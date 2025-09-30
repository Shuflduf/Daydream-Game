class_name UI
extends Control

@onready var energy: PanelContainer = %Energy
@onready var arrow: PanelContainer = %Arrow
@onready var item_tooltips: Node = $ItemTooltips
@onready var transition: ColorRect = $Transition
@onready var world: Node2D = %World
@onready var endscreen: MarginContainer = %EndScreen

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"next") and LevelHandler.has_next_unlocked():
		LevelHandler.current_level += 1
		get_tree().change_scene_to_file(scene_file_path)
	elif event.is_action_pressed(&"restart"):
		get_tree().change_scene_to_file(scene_file_path)
func _ready() -> void:
	transition.show()
	transition.open()
	transition.opened.connect(func(): world.enabled = true)

func set_item(first: bool, id: StringName):
	$ItemTooltips.set_item(first, id)
	var tile_pos: Vector2i
	if id.is_empty():
		tile_pos = Vector2i(3, 3)
	else:
		tile_pos = Interactables.ATLAS[id]
	var atlas_pos = Vector2(tile_pos * 8)
	var target_tex = %TexOne if first else %TexTwo
	target_tex.texture.region.position = atlas_pos


func set_tooltip(data: Dictionary[String, String]):
	%TooltipLabel.text = ""
	for entry in data:
		#%TooltipLabel.text += " "
		%TooltipLabel.text += entry
		%TooltipLabel.text += ":\n "
		%TooltipLabel.text += data[entry]
		%TooltipLabel.text += "\n"
	#%TooltipLabel.text += "}"


func _on_area_2d_mouse_entered() -> void:
	print("A")
