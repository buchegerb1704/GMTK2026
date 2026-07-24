extends Node

#@onready var anim: AnimationPlayer = $AnimationPlayer

#func _ready() -> void:
	#anim.play("text_fade")

func _input(event: InputEvent) -> void:
	if (event.is_pressed() and event is InputEventKey or event is InputEventJoypadButton):
		if (event.is_action_pressed("exit")):
			load_next()

func load_next() -> void:
	Gamestate.options.start_menu = false;
