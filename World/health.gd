class_name Health
extends Node

signal die
signal changed(new_health: int)

@export var max_health: int = 3
@onready var current = max_health


func shift(amount: int):
	current = clamp(current + amount, 0, max_health)
	changed.emit(current)
	if current == 0:
		die.emit()
