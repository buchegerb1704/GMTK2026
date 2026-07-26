extends Cutscene

@export var main_menu_button: Button

@export var win_anim: AnimatedSprite2D
@export var anim_player: AnimationPlayer

@export var music_audio: AudioStreamPlayer
@export var sfx_audio: AudioStreamPlayer

@export var sound_list: Array[AudioStreamWAV]
@export var music_list: Array[AudioStreamWAV]

@export var credits_list: Array[TextureRect]

func _ready() -> void:
	main_menu_button.visible = false
	win_anim.visible = false
	for credit in credits_list:
		credit.modulate.a = 0
		credit.visible = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "car_move_animation"):
		music_audio.stop()
		sfx_audio.stream = sound_list[1]
		sfx_audio.play()
	elif (anim_name == "blackscreen"):
		for credit in credits_list:
			credit.visible = true
		music_audio.stream = music_list[0]
		music_audio.play()
		anim_player.play("credits")
	elif (anim_name == "credits"):
		main_menu_button.visible = true

func _on_sfx_player_finished() -> void:
	if (sfx_audio.stream == sound_list[1]):
		win_anim.visible = true
		win_anim.play("enter")
		sfx_audio.stream = sound_list[2]
		sfx_audio.play()
		anim_player.play("fade_in")
	elif (sfx_audio.stream == sound_list[6]):
		anim_player.play("blackscreen")

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
