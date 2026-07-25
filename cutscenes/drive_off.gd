extends Cutscene

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		Scenes.goto_by_name("res://ui/errand_picker.tscn")
