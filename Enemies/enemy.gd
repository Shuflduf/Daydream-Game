class_name Enemy
extends Entity

@warning_ignore("unused_signal")
signal map_tiles_requested

@onready var health: Health = $Health
@onready var player = get_tree().get_first_node_in_group(&"Player")
@onready var tooltip: Area2D = $Tooltip

var enabled = false
var map_tiles: Array[Vector2i]


func _ready() -> void:
	tooltip.data["health"] = str(health.current)


func cycle():
	return


func fake_move():
	bump(-player.last_move)


func _on_health_die() -> void:
	queue_free()
	tooltip.remove()


func _on_screen_entered() -> void:
	enabled = true


func _on_health_changed(new_health: int) -> void:
	tooltip.data["health"] = str(new_health)
	tooltip.update()
