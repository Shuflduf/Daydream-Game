extends Area2D

@onready var ui: Control = get_tree().get_first_node_in_group(&"UI")

func _on_mouse_entered() -> void:
	ui.set_tooltip({"balls": "2"})
