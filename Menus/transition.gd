extends ColorRect

signal opened
signal closed


func open(speed: float = 1.0):
	while position.y < size.y:
		$SFX.play()
		position.y = clampf(position.y + 64.0 * speed, 0.0, size.y)
		await get_tree().create_timer(0.2).timeout
	$Finish.play()
	position.y = size.y
	opened.emit()


func close(speed: float = 1.0):
	while position.y > 0.0:
		$SFX.play()
		position.y = clampf(position.y - 64.0 * speed, 0.0, size.y)
		await get_tree().create_timer(0.2).timeout
	$Finish.play()
	position.y = 0.0
	closed.emit()
