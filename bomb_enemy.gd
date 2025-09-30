extends Enemy

var can_move = true

func _ready() -> void:
	super()
	tooltip.data["name"] = "Bob"

func cycle():
	if can_move:
		tile_pos.x -= 1
		can_move = false
	else:
		can_move = true
