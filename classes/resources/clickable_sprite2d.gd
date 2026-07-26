class_name ClickableArea2D extends Area2D

signal clicked

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is not InputEventMouseButton:
		return
	
	var mb_event: InputEventMouseButton = event
	if mb_event.pressed and mb_event.button_index == MOUSE_BUTTON_LEFT:
		@warning_ignore("return_value_discarded") emit_signal(clicked.get_name())
