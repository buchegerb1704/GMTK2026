extends Node

var player: AudioStreamPlayer

enum Stem { INTRO, MENU_A, MENU_B, MENU_TRANS, IDLE_A, IDLE_B, IDLE_C, IDLE_TRANS, GAME_A, GAME_B, GAME_C }

var _stems: Dictionary[Stem, AudioStreamWAV] = {
	Stem.INTRO: preload("res://assets/music/intro.wav"),
	Stem.MENU_A: preload("res://assets/music/menuA.wav"),
	Stem.MENU_B: preload("res://assets/music/menuB.wav"),
	Stem.MENU_TRANS: preload("res://assets/music/menutransition.wav"),
	Stem.IDLE_A: preload("res://assets/music/idleA.wav"),
	Stem.IDLE_B: preload("res://assets/music/idleB.wav"),
	Stem.IDLE_C: preload("res://assets/music/idleC.wav"),
	Stem.IDLE_TRANS: preload("res://assets/music/idletransition.wav"),
	Stem.GAME_A: preload("res://assets/music/gameplayA.wav"),
	Stem.GAME_B: preload("res://assets/music/gameplayB.wav"),
	Stem.GAME_C: preload("res://assets/music/gameplayC.wav"),
}

var _current_stem: Stem

var next_stem: Stem

func play_stem(stem: Stem) -> void:
	player.stream = _stems[stem]
	player.play()
	_current_stem = stem
	next_stem = _calculate_next()

func switch_gameplay() -> void:
	pass

func switch_idle() -> void:
	pass

func _calculate_next() -> Stem:
	match _current_stem:
		Stem.INTRO: return Stem.MENU_A
		Stem.MENU_A: return Stem.MENU_B if randf() < 0.4 else Stem.MENU_A
		Stem.MENU_B: return Stem.MENU_A if randf() < 0.4 else Stem.MENU_B
		Stem.MENU_TRANS: return Stem.GAME_A
		Stem.IDLE_A: return [Stem.IDLE_B, Stem.IDLE_C].pick_random() if randf() < 0.3 else Stem.IDLE_A
		Stem.IDLE_B: return [Stem.IDLE_A, Stem.IDLE_C].pick_random() if randf() < 0.3 else Stem.IDLE_B
		Stem.IDLE_C: return [Stem.IDLE_A, Stem.IDLE_B].pick_random() if randf() < 0.3 else Stem.IDLE_C
		Stem.IDLE_TRANS: return [Stem.GAME_A, Stem.GAME_B, Stem.GAME_C].pick_random()
		Stem.GAME_A: return Stem.IDLE_A
		Stem.GAME_B: return Stem.IDLE_B
		Stem.GAME_C: return Stem.IDLE_C
	return Stem.INTRO

func _ready() -> void:
	player = AudioStreamPlayer.new()
	player.bus = &"Music"
	player.finished.connect(_handle_finished)
	self.add_child(player)
	
	play_stem(Stem.INTRO)

func _handle_finished() -> void:
	play_stem(next_stem)
