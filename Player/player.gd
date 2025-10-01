extends Entity

@onready var health: Health = $Health
@onready var ui: Control = get_tree().get_first_node_in_group(&"UI")

signal moved(new_tile_pos: Vector2i)
signal item_used(face_dir: Vector2i, id: StringName)

var last_move: Vector2i

var item_one: StringName
var item_two: StringName

const DIRS = {
	&"down": Vector2i(0, 1),
	&"up": Vector2i(0, -1),
	&"left": Vector2i(-1, 0),
	&"right": Vector2i(1, 0),
}


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"item_one"):
		use_item(true)
	elif event.is_action_pressed(&"item_two"):
		use_item(false)
	for dir in DIRS:
		if event.is_action_pressed(dir):
			last_move = DIRS[dir]
			
			moved.emit(tile_pos + DIRS[dir])

			#tile_pos += DIRS[dir]
			if dir == &"left":
				$Sprite.flip_h = true
			elif dir == &"right":
				$Sprite.flip_h = false
			break


func actually_move():
	$Walk.play()
	tile_pos += last_move


func fake_move():
	bump(last_move)


func accept_item(id: StringName) -> bool:
	if item_one.is_empty():
		item_one = id
		ui.set_item(true, id)
		return true
	elif item_two.is_empty():
		item_two = id
		ui.set_item(false, id)
		return true
	return false


func cancel_move():
	tile_pos -= last_move


func reset_item(first: bool):
	ui.set_item(first, &"")
	if first:
		item_one = &""
	else:
		item_two = &""


func use_item(first: bool):
	var target_id = item_one if first else item_two
	item_used.emit(last_move, target_id)
	reset_item(first)
	#match target_id:
	#&"sword":
	#
	#print(tile_in_front)
	#reset_item(first)
	#var enemies = EnemyUtils.get_enemy_tiles()
	#if enemies.has(tile_in_front):
	#enemies[tile_in_front].health.shift(-3)
	#moved.emit(tile_pos)
	#else:
	#var t = last_move
	#last_move = Vector2i.ZERO
	#moved.emit(tile_in_front)
	#last_move = t


func heal():
	$Heal.play()


func _on_health_changed(new_health: int) -> void:
	ui.energy.current_energy = new_health
	ui.energy.update_bars()


func _on_health_die() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite, ^"modulate", Color.BLACK, 1.0)
	#tween.parallel().tween_property($Sprite, ^"scale", Vector2.ZERO, 1.0)
