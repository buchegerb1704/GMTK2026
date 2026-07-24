@tool
extends NinePatchRect

@onready var fx_label: RichTextLabel = $FXVolume/FXVolumeLabel
@onready var fx_slider: HSlider = $FXVolume/FXVolumeSlider
@onready var music_label: RichTextLabel = $MusicVolume/MusicVolumeLabel
@onready var music_slider: HSlider = $MusicVolume/MusicVolumeSlider
var sfx: = AudioServer.get_bus_index("SFX")
var music: = AudioServer.get_bus_index("Music")

func _ready() -> void:
	fx_slider.value = AudioServer.get_bus_volume_linear(sfx)
	music_slider.value = AudioServer.get_bus_volume_linear(music)

func _on_volume_slider_mouse_exited() -> void:
	release_focus()

func _on_fx_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(sfx, value)
	change_display_text(fx_label, fx_slider)

func _on_music_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(music, value)
	change_display_text(music_label, music_slider)

func change_display_text(text_element: RichTextLabel, slider: HSlider) -> void:
	text_element.text = "{0}%".format([snapped(slider.value * 100, 1)])
