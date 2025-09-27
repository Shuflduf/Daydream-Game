class_name Health
extends Node

signal die

@export var max_health: int = 3
var current = max_health

func shift(amount: int):
	current = clamp(current + amount, 0, max_health)
	if current >= 0:
		die.emit()
