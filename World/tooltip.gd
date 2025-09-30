extends Area2D

@onready var ui: Control = get_tree().get_first_node_in_group(&"UI")

var data: Dictionary[String, String] = {}


func update():
	ui.set_tooltip(data)


func remove():
	ui.set_tooltip({} as Dictionary[String, String])


func _on_mouse_entered() -> void:
	update()


func _on_mouse_exited() -> void:
	remove()
