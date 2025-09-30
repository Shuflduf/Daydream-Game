extends Node2D

@onready var player: Node2D = $Player
@onready var enemies_parent: Node2D = $Enemies
@onready var finish_line: Line2D = $FinishLine
@onready var ui: Control = get_tree().get_first_node_in_group(&"UI")


var finish_pos: int
var enabled = false

var finish_data = {
	"damage_taken": 0,
	"tiles_walked": 0,
	"rock_eaten": 0,
	"enemies_left": 0,
	"coins_collected": 0,
}

func cycle():
	$Interactable.cycle()
	for enemy in get_tree().get_nodes_in_group(&"Enemy"):
		enemy.cycle()


func _ready() -> void:
	EnemyUtils.bomb_enemy_exploded.connect(detonate_bomb)
	EnemyUtils.interactable_added.connect($Interactable.add_interactable)
	for enemy in enemies_parent.get_children():
		finish_data["enemies_left"] += 1
		enemy.health.die.connect(func(): finish_data["enemies_left"] -= 1)
		enemy.map_tiles_requested.connect(func(): enemy.map_tiles = get_collision_tiles())
	finish_pos = $Walls.get_rightmost() + 4
	finish_line.position.x = finish_pos * 8.0
	#generate_rock(Vector2i(8, 4), 8.3)


func generate_rock(offset: Vector2i, diameter: float):
	var placed: Array[Vector2i]
	var radius = diameter / 2
	for x in ceili(diameter):
		var x_pos = x - radius
		for y in ceili(diameter):
			var y_pos = y - radius
			var dist_to_cent = sqrt((x_pos * x_pos) + (y_pos * y_pos))
			if dist_to_cent > radius:
				continue
			var place_pos = Vector2i(int(x_pos) + offset.x, int(y_pos) + offset.y)
			if place_pos in placed:
				continue
			if randf() < 0.95:
				$Walls.tiles.append(place_pos)
			else:
				$Interactable.add_interactable(place_pos, &"bomb")
			placed.append(place_pos)
	$Walls.place_tiles()


func _on_player_moved(new_tile_pos: Vector2i) -> void:
	if not enabled:
		return
	ui.arrow.change_direction(atan2(player.last_move.x, -player.last_move.y))
	var enemies = EnemyUtils.get_enemy_tiles()
	if new_tile_pos.y < 0 or new_tile_pos.y >= 8:
		player.fake_move()
	elif new_tile_pos in $Walls.tiles:
		#player.cancel_move()
		#$Walls.tiles.erase(new_tile_pos)
		player.health.shift(-1)
		player.fake_move()
		finish_data["rock_eaten"] += 1
		$Eat.play()
		$Walls.remove_at(new_tile_pos)
		#$Walls.tiles = $Walls.tiles.filter(func(t): return t != new_tile_pos)
		$Walls.place_tiles()
	elif new_tile_pos in $Interactable.tiles:
		#player.cancel_move()
		player.fake_move()
		$Interactable.interact(new_tile_pos)
	elif new_tile_pos in enemies:
		enemies[new_tile_pos].health.shift(-1)
		enemies[new_tile_pos].fake_move()
		player.fake_move()
		player.health.shift(-1)
		finish_data["damage_taken"] += 1
		$Attack.play()
	else:
		finish_data["tiles_walked"] += 1
		player.actually_move()
		$Camera.update_focus(new_tile_pos.x)
		if new_tile_pos.x >= finish_pos:
			level_end_sequence()
	cycle()


func level_end_sequence():
	print(finish_data)
	enabled = false
	$Camera.update_focus(finish_pos+5)
	ui.endscreen.raw_stats = finish_data
	await ui.endscreen.update_stats()
	ui.endscreen.show_challenges()

func get_collision_tiles() -> Array[Vector2i]:
	var all: Array[Vector2i] = []
	all.append_array($Walls.tiles)
	all.append_array($Interactable.tiles)
	return all


func _on_interactable_explode_bomb(pos: Vector2i) -> void:
	detonate_bomb(pos)


func detonate_bomb(pos: Vector2i):
	var explode_radius = 2.5
	var ep = floori(explode_radius)
	var enemies = EnemyUtils.get_enemy_tiles()
	for x in range(-ep, ep + 1):
		for y in range(-ep, ep + 1):
			var length = sqrt((x * x) + (y * y))
			if length > explode_radius:
				continue
			var target_pos = pos + Vector2i(x, y)
			$Walls.remove_at(target_pos)
			if player.tile_pos == target_pos:
				player.health.shift(-4)
				finish_data["rock_eaten"] += 4
			elif enemies.has(target_pos):
				enemies[target_pos].health.shift(-4)
	$Walls.place_tiles()
	$Bomb.play()


func _on_player_item_used(face_dir: Vector2i, id: StringName) -> void:
	var target_tile = player.tile_pos + face_dir
	match id:
		&"sword":
			var enemies = EnemyUtils.get_enemy_tiles()
			if enemies.has(target_tile):
				$Sword.play()
				enemies[target_tile].health.shift(-3)
			elif target_tile in $Walls.tiles:
				$Sword.play()
				var walls_broken = 0
				while $Walls.tiles.has(target_tile) and walls_broken < 3:
					$Attack.play()
					$Walls.remove_at(target_tile)
					target_tile += face_dir
					walls_broken += 1
					finish_data["rock_eaten"] += 1
				#$Walls.remove_at(target_tile)
				$Walls.place_tiles()
			else:
				# this might be fucking stupid
				player.heal()
				player.health.shift(2)
			cycle()
		&"bomb":
			#if $Interactable.
			$Interactable.add_interactable(target_tile, id)
			$Interactable.trigger_bomb(target_tile)
		&"potion":
			player.heal()
			player.health.shift(4)


func _on_interactable_coin_collected() -> void:
	finish_data["coins_collected"] += 1
