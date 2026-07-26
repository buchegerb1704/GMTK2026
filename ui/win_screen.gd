extends Cutscene

@export var win_anim: AnimatedSprite2D
@export var anim_player: AnimationPlayer

@export var music_audio: AudioStreamPlayer
@export var sfx_audio: AudioStreamPlayer
@export var sound_list: Array[AudioStreamWAV]

func _ready() -> void:
	win_anim.visible = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "car_move_animation"):
		music_audio.stop()
		sfx_audio.stream = sound_list[1]
		sfx_audio.play()

func _on_sfx_player_finished() -> void:
	if (sfx_audio.stream == sound_list[1]):
		win_anim.visible = true
		win_anim.play("enter")
		sfx_audio.stream = sound_list[2]
		sfx_audio.play()
		anim_player.play("fade_in")

func _on_win_anim_animation_finished() -> void:
	if win_anim.animation == "enter":
		win_anim.play("pillow_fluff")
		sfx_audio.stream = sound_list[3]
		sfx_audio.play()
	elif win_anim.animation == "pillow_fluff":
		win_anim.play("pillow_zflip")
		sfx_audio.stream = sound_list[4]
		sfx_audio.play()
	elif win_anim.animation == "pillow_zflip":
		win_anim.play("sleep")
		sfx_audio.stream = sound_list[5]
		sfx_audio.play()
	elif win_anim.animation == "sleep":
		sfx_audio.stream = sound_list[6]
		sfx_audio.play()
	pass # Replace with function body.
