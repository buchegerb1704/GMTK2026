extends AudioStreamPlayer

@export var tracks: Array[AudioStream] = []
var playing_track: int = -1

const DRONE_IDX: int = 5

var droning: bool = false
var stored_time: float

func _process(_delta: float) -> void:
	if Gamestate.options.start_menu or droning:
		return

	if playing_track == -1:
		switch_tracks(0, Gamestate.options.ambient_start_time)
	elif playing_track < Gamestate.save_data.keys_acquired:
		var current_time := self.get_playback_position() + AudioServer.get_time_since_last_mix()
		switch_tracks(Gamestate.save_data.keys_acquired, current_time)

func switch_tracks(index: int, start_time: float) -> void:
	self.stream = tracks[index]
	self.play(start_time)
	self.playing_track = index

func start_drone() -> void:
	self.droning = true
	self.stored_time = self.get_playback_position() + AudioServer.get_time_since_last_mix()
	switch_tracks(DRONE_IDX, 0)

func end_drone() -> void:
	self.droning = false
	switch_tracks(Gamestate.save_data.keys_acquired, self.stored_time)
