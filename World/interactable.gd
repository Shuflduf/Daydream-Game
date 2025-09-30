class_name Interactables
extends TileMapLayer

signal explode_bomb(pos: Vector2i)

const LABEL_OFFSET = Vector2(1.0, 0.0)
const ATLAS = {
	&"chest": Vector2i(2, 0),
	&"sword": Vector2i(3, 0),
	&"bomb": Vector2i(1, 2),
	&"potion": Vector2i(2, 3),
	&"coin": Vector2i(1, 4),
}

var bombs: Dictionary[Vector2i, int]
var tiles: Array[Vector2i]

@onready var player = get_tree().get_first_node_in_group(&"Player")


func _ready() -> void:
	tiles = get_used_cells()


func cycle():
	for label in $BombLabels.get_children():
		label.queue_free()
	for bomb_pos in bombs:
		bombs[bomb_pos] -= 1
		var bomb_timer = bombs[bomb_pos]
		if bomb_timer <= 0:
			erase_cell(bomb_pos)
			tiles.erase(bomb_pos)
			explode_bomb.emit(bomb_pos)
			bombs.erase(bomb_pos)
		else:
			add_label(bomb_pos)
			bomb_sound(bomb_timer)


func bomb_sound(timer: int):
	$Bomb.pitch_scale = remap(timer, 1.0, 3.0, 0.5, 1.0)
	$Bomb.play()


func add_label(pos: Vector2i):
	var new_label = $BaseLabel.duplicate()
	new_label.visible = true
	new_label.position = Vector2(pos * 8) + LABEL_OFFSET
	new_label.text = str(bombs[pos])
	$BombLabels.add_child(new_label)


func add_interactable(pos: Vector2i, id: StringName):
	tiles.erase(pos)
	tiles.append(pos)
	set_cell(pos, 0, ATLAS[id])


func trigger_bomb(pos: Vector2i):
	bombs[pos] = 3
	add_label(pos)
	bomb_sound(3)


func interact(pos: Vector2i):
	var tile_id = get_cell_tile_data(pos).get_custom_data("id")
	#tiles.erase(pos)

	match tile_id:
		&"chest":
			$Chest.play()
			pickup_particles(pos, tile_id)
			set_cell(pos, 0, ATLAS[&"sword"])
		&"sword", &"potion":
			if player.accept_item(tile_id):
				$Pickup.play()
				erase_cell(pos)
				tiles.erase(pos)
		&"bomb":
			if not bombs.has(pos) and player.accept_item(tile_id):
				$Pickup.play()
				erase_cell(pos)
				tiles.erase(pos)
		&"coin":
			pickup_particles(pos, tile_id)
			erase_cell(pos)
			tiles.erase(pos)
			$Pickup.play()
	print(tile_id)


func pickup_particles(pos: Vector2i, id: StringName):
	var new_particles = $GrabParticles.duplicate()
	new_particles.texture.region.position = Vector2(ATLAS[id] * 8)
	new_particles.position = Vector2(pos * 8) + Vector2(4.0, 4.0)
	add_child(new_particles)
	new_particles.restart()
	new_particles.finished.connect(func(): new_particles.queue_free())
