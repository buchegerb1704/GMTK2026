extends AnimatedSprite2D

func _process(delta: float) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	self.set_position(mouse_pos)
		 
