extends Node

enum Stem { INTRO, MENU_A, MENU_B, MENU_TRANS, IDLE_A, IDLE_B, IDLE_C, IDLE_TRANS, GAME_A, GAME_B, GAME_C, LULLABY, NONE }

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
	Stem.LULLABY: preload("res://assets/music/Lullabyforalegendbutlouder.wav")
}

var _player: AudioStreamPlayer
var _current_stem: Stem
var next_stem: Stem

func play_stem(stem: Stem) -> void:
	if stem == Stem.NONE:
		stop()
	else:
		_player.stream = _stems[stem]
		_player.play()
		_current_stem = stem
		next_stem = _calculate_next()

func play_stem_next(stem: Stem) -> void:
	if _player.playing:
		next_stem = stem
	else:
		play_stem(stem)

func stop() -> void:
	_player.stop()
	_current_stem = Stem.NONE
	next_stem = Stem.NONE

func switch_gameplay() -> void:
	match _current_stem:
		Stem.INTRO: next_stem = Stem.MENU_TRANS
		Stem.MENU_A: next_stem = Stem.MENU_TRANS
		Stem.MENU_B: next_stem = Stem.MENU_TRANS
		Stem.IDLE_A: next_stem = Stem.IDLE_TRANS
		Stem.IDLE_B: next_stem = Stem.IDLE_TRANS
		Stem.IDLE_C: next_stem = Stem.IDLE_TRANS

func _calculate_next() -> Stem:
	match _current_stem:
		Stem.INTRO: return Stem.MENU_A
		Stem.MENU_A: return Stem.MENU_B if randf() < 0.4 else Stem.MENU_A
		Stem.MENU_B: return Stem.MENU_A if randf() < 0.4 else Stem.MENU_B
		Stem.MENU_TRANS: return Stem.GAME_A
		Stem.IDLE_A: return Stem.IDLE_B if randf() < 0.4 else Stem.IDLE_A
		Stem.IDLE_B: return Stem.IDLE_C if randf() < 0.2 else Stem.IDLE_B
		Stem.IDLE_C: return Stem.IDLE_B if randf() < 0.2 else Stem.IDLE_C
		Stem.IDLE_TRANS: return [Stem.GAME_A, Stem.GAME_B, Stem.GAME_C].pick_random()
		Stem.GAME_A: return Stem.IDLE_A
		Stem.GAME_B: return Stem.IDLE_A
		Stem.GAME_C: return Stem.IDLE_A
	return Stem.NONE

func _ready() -> void:
	_player = AudioStreamPlayer.new()
	_player.bus = &"Music"
	@warning_ignore("return_value_discarded") _player.finished.connect(_handle_finished)
	self.add_child(_player)

func _handle_finished() -> void:
	play_stem(next_stem)
