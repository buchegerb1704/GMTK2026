extends Control

@export var options_menu: TextureRect

@export var sound_volume_label: Label
@export var music_volume_label: Label

@export var menu_sfx: AudioStreamPlayer

@export var sfx_list: Array[AudioStreamWAV]

var sfx := AudioServer.get_bus_index("SFX")
var music := AudioServer.get_bus_index("Music")

var _sfx_volume: float = 1.0
var _music_volume: float = 1.0

func _ready() -> void:
	Music.play_stem_next(Music.Stem.MENU_A)
	options_menu.visible = false
	_sfx_volume = AudioServer.get_bus_volume_linear(sfx)
	_music_volume =AudioServer.get_bus_volume_linear(music)
	_reset_label_text()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_start_button_pressed() -> void:
	Music.switch_gameplay()
	Errands.reset_errands()
	Scenes.next = load("res://ui/errand_picker.tscn")
	Scenes.goto_by_name("res://cutscenes/driving.tscn")

func _on_options_button_pressed() -> void:
	options_menu.visible = true

func _on_options_back_button_pressed() -> void:
	menu_sfx.stream = sfx_list[3]
	menu_sfx.play()
	options_menu.visible = false

func _on_sounds_louder_button_pressed() -> void:
	if (_sfx_volume + 0.1 <= 1):
		menu_sfx.stream = sfx_list[0]
		menu_sfx.play()
		_sfx_volume = _sfx_volume + 0.1
		_reset_label_text()

func _on_sounds_quieter_button_pressed() -> void:
	if (_sfx_volume - 0.1 >= 0):
		menu_sfx.stream = sfx_list[1]
		menu_sfx.play()
		_sfx_volume = _sfx_volume - 0.1
		_reset_label_text()

func _on_music_louder_button_pressed() -> void:
	if (_music_volume + 0.1 <= 1):
		menu_sfx.stream = sfx_list[0]
		menu_sfx.play()
		_music_volume = _music_volume + 0.1
		_reset_label_text()

func _on_music_quieter_button_pressed() -> void:
	if (_music_volume - 0.1 >= 0):
		menu_sfx.stream = sfx_list[1]
		menu_sfx.play()
		_music_volume = _music_volume - 0.1
		_reset_label_text()

func _reset_label_text() -> void:
	AudioServer.set_bus_volume_linear(sfx, _sfx_volume)
	AudioServer.set_bus_volume_linear(music, _music_volume)
	sound_volume_label.text = "%d" % (_sfx_volume * 100)
	music_volume_label.text = "%d" % (_music_volume * 100)
