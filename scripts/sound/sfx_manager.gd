extends AudioStreamPlayer

func load_sfx(sfx_to_load: AudioStream, volume: float) -> void:
	self.stream = sfx_to_load
	self.volume_db = volume - 3
	self.play()
