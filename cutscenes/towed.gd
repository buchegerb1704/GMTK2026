extends Cutscene

func _ready() -> void:
	Music.stop()
	SFX.play_sound(preload("res://assets/sounds/carcrash_short.wav"),
		func() -> void:
			#SFX.play_sound(Config.SFX_DEMEANING.pick_random())
			SFX.play_sound(preload("res://assets/sounds/Hedied.wav"))
	)
