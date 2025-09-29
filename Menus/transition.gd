extends ColorRect

func open(speed: float = 1.0):
	while position.y < size.y:
		position.y += 32.0
		await get_tree().create_timer(0.1 / speed).timeout
