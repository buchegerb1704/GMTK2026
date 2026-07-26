class_name Errand extends Control

signal errand_finished

func finish_errand(..._args: Array) -> void:
	@warning_ignore("unsafe_call_argument")
	SFX.play_sound(Config.SFX_PRAISE.pick_random())
	SFX.play_sound(Config.SUCCESS_SOUND)
	errand_finished.emit()
	Errands.finish()
