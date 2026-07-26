extends Node

## Number of SFX players to create.
const POLYPHONY: int = 8

class SFXPlayer extends Resource:
	var _player: AudioStreamPlayer
	var _callback: Callable
	
	signal ready
	
	func play(sfx: AudioStream, callback: Callable = Callable()) -> void:
		self._player.stream = sfx
		self._player.play()
		self._callback = callback
	
	func reset() -> void:
		self._callback = Callable()
	
	func _init() -> void:
		self._callback = Callable()
		self._player = AudioStreamPlayer.new()
		self._player.bus = &"SFX"
		@warning_ignore("return_value_discarded") self._player.finished.connect(self._player_ended)
	
	func _player_ended() -> void:
		if self._callback.is_valid():
			self._callback.call()
		self.ready.emit()

var _sfx_players: Array[SFXPlayer]
var _free_players: Array[SFXPlayer]

## Returns false if no players available.
func play_sound(sfx: AudioStream, callback: Callable = Callable()) -> void:
	var player: SFXPlayer = _free_players.pop_front()
	if player:
		player.play(sfx, callback)

func _ready_player(player: SFXPlayer) -> void:
	player.reset()
	_free_players.push_back(player)

func _ready() -> void:
	for idx in POLYPHONY:
		var new_player := SFXPlayer.new()
		@warning_ignore("return_value_discarded") new_player.ready.connect(_ready_player.bind(new_player))
		self.add_child(new_player._player)
		_sfx_players.append(new_player)
	
	_free_players = _sfx_players.duplicate()
