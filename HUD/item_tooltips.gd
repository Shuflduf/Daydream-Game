extends Node

@onready var interface: UI = $".."

var item_one: StringName
var item_two: StringName

const TOOLTIPS = {
	&"sword": {"damage": "3", "health": "2"},
	&"potion": {"health": "4"},
	&"bomb": {"radius": "3", "damage": "4"},
}


func set_item(first: bool, id: StringName):
	if first:
		item_one = id
	else:
		item_two = id


func set_empty():
	interface.set_tooltip({} as Dictionary[String, String])


func cast(data: Dictionary) -> Dictionary[String, String]:
	var t: Dictionary[String, String]
	for key in data:
		t[key] = data[key]
	return t


func _on_tex_one_mouse_entered() -> void:
	if item_one.is_empty():
		set_empty()
	else:
		interface.set_tooltip(cast(TOOLTIPS[item_one]))


func _on_tex_one_mouse_exited() -> void:
	set_empty()


func _on_tex_two_mouse_entered() -> void:
	if item_two.is_empty():
		set_empty()
	else:
		interface.set_tooltip(cast(TOOLTIPS[item_two]))


func _on_tex_two_mouse_exited() -> void:
	set_empty()
