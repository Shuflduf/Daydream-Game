extends PanelContainer

@onready var sprite: Sprite2D = $SubViewportContainer/SubViewport/Sprite


func change_direction(angle: float):
	sprite.rotation = angle
