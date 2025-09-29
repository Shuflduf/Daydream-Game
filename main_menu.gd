extends Control
@onready var transition: ColorRect = $Transition

func _ready() -> void:
	transition.open(0.5)
