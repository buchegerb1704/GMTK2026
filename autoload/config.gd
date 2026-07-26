extends Node

const NUM_ERRANDS: int = 5
#const ERRANDS_MIN: int = 3
#const ERRANDS_MAX: int = 5

const START_COINS: int = 12

const SUCCESS_SOUND := preload("res://assets/sounds/shortsparkle.wav")

const SFX_DEMEANING: Array[AudioStream] = [
	preload("res://assets/sounds/character_voices/demeaning1.wav"),
	preload("res://assets/sounds/character_voices/demeaning2.wav"),
	preload("res://assets/sounds/character_voices/demeaning3.wav"),
	preload("res://assets/sounds/character_voices/demeaning4.wav"),
	preload("res://assets/sounds/character_voices/demeaning5.wav"),
	preload("res://assets/sounds/character_voices/demeaning6.wav"),
]

const SFX_GRUNT: Array[AudioStream] = [
	preload("res://assets/sounds/character_voices/grunt1.wav"),
	preload("res://assets/sounds/character_voices/grunt2.wav"),
	preload("res://assets/sounds/character_voices/grunt3.wav"),
	preload("res://assets/sounds/character_voices/grunt4.wav"),
	preload("res://assets/sounds/character_voices/grunt5.wav"),
	preload("res://assets/sounds/character_voices/grunt6.wav"),
]

const SFX_PRAISE: Array[AudioStream] = [
	preload("res://assets/sounds/character_voices/praise1.wav"),
	preload("res://assets/sounds/character_voices/praise2.wav"),
	preload("res://assets/sounds/character_voices/praise3.wav"),
	preload("res://assets/sounds/character_voices/praise4.wav"),
	preload("res://assets/sounds/character_voices/praise5.wav"),
	preload("res://assets/sounds/character_voices/praise6.wav"),
]

const SFX_THINK: Array[AudioStream] = [
	preload("res://assets/sounds/character_voices/think1.wav"),
	preload("res://assets/sounds/character_voices/think2.wav"),
	preload("res://assets/sounds/character_voices/think3.wav"),
	preload("res://assets/sounds/character_voices/think4.wav"),
	preload("res://assets/sounds/character_voices/think5.wav"),
	preload("res://assets/sounds/character_voices/think6.wav"),
]
