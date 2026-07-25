extends Cutscene

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "car_move_animation":
		self.end_cutscene()
