extends MarginContainer

@onready var stats: VBoxContainer = $HBoxContainer/Stats
@onready var base_stat: HBoxContainer = $HBoxContainer/BaseStat
@onready var base_challenge: HBoxContainer = $HBoxContainer/BaseChallenge
@onready var challenges: VBoxContainer = $HBoxContainer/Challenges

var raw_stats: Dictionary

func update_stats():
	for child in stats.get_children():
		child.queue_free()
	for stat in raw_stats:
		var new_stat = base_stat.duplicate()
		stats.add_child(new_stat)
		new_stat.show()
		new_stat.get_child(0).text = stat
		new_stat.get_child(1).text = str(raw_stats[stat])
		$Reveal.play()
		await get_tree().create_timer(0.2).timeout
		
func show_challenges():
	for child in challenges.get_children():
		child.queue_free()
	await add_challenge("No Damage", raw_stats["damage_taken"] <= 0)
	await add_challenge("All Coins", raw_stats["coins_collected"] >= 3)
	await add_challenge("No Mercy", raw_stats["enemies_left"] <= 0)
	

func add_challenge(challenge_name: String, passed: bool):
	await get_tree().create_timer(0.5).timeout
	var new_challenge = base_challenge.duplicate()
	challenges.add_child(new_challenge)
	new_challenge.show()
	new_challenge.get_child(0).text = challenge_name
	new_challenge.get_child(1).material = new_challenge.get_child(1).material.duplicate()
	new_challenge.get_child(1).material.set_shader_parameter(&"enabled", not passed)
	($Success if passed else $Failed).play()
	
