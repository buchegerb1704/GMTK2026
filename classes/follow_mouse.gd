extends TextureRect

var mousepositoion: int

func _process (delta: float) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var pivot_pos: Vector2 = mouse_pos - self.pivot_offset
	self.set_position(pivot_pos)
