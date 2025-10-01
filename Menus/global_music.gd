extends AudioStreamPlayer

func _ready() -> void:
	stream = preload("res://Assets/music-fireentity.wav")
	volume_db = -15.0
	#pitch_scale = 0.9
	#play()

func set_pitch(new_pitch: float):
	var tween = get_tree().create_tween()
	tween.tween_property(self, ^"pitch_scale", max(0.1, new_pitch), 0.5)
	if new_pitch == 0.0:
		tween.tween_property(self, ^"playing", false, 0.0)
