extends ColorRect

@onready var menus: NinePatchRect = $Menus

func _ready() -> void:
	self.hide()

func _input(event: InputEvent) -> void:
	if (event.is_action_released("exit")):
		get_tree().paused = true
		self.show();
		get_viewport().set_input_as_handled()
