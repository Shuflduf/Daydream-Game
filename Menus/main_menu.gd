extends Control
@onready var transition: ColorRect = $Transition

var active = false

func _ready() -> void:
	transition.show()
	transition.open(0.5)
	transition.opened.connect(func(): active = true)
	transition.closed.connect(func(): get_tree().change_scene_to_file("res://HUD/interface.tscn"))


func _input(event: InputEvent) -> void:
	if not active:
		return
	if event.is_action_pressed(&"start"):
		transition.close()
		active = false
		$Action.play()
	elif event.is_action_pressed(&"levels"):
		$Action.play()
		get_tree().change_scene_to_file("res://Menus/levels_list.tscn")
	elif event.is_action_pressed(&"quit"):
		get_tree().quit()
