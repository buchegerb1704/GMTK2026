extends Cutscene

@export var car_anim: AnimatedSprite2D

@export var sfx_player: AudioStreamPlayer
@export var sfx_sounds: Array[AudioStreamWAV]

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		Scenes.goto_by_name("res://ui/errand_picker.tscn")

func _on_car_drive_off_anim_animation_finished() -> void:
	if car_anim.animation == "default":
		sfx_player.stream = sfx_sounds[0]
		sfx_player.play()
		car_anim.play("drive_off")
