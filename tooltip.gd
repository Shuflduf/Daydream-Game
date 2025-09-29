extends Area2D

@onready var ui: Control = get_tree().get_first_node_in_group(&"UI")

var data: Dictionary[String, String] = {"balls": "2"}

func _on_mouse_entered() -> void:
	ui.set_tooltip(data)


func _on_mouse_exited() -> void:
	ui.set_tooltip({} as Dictionary[String, String])
		
