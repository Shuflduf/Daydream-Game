extends Control
@onready var transition: ColorRect = $Transition


func _ready() -> void:
	transition.open(0.5)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"start"):
		transition.close()
