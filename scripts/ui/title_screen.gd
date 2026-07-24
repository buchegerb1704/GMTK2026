extends Node

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var playing: bool = false;
@export var FirstRoom: StringName;

func _ready() -> void:
	anim.play("text_fade")

func _input(event: InputEvent) -> void:
	if (event.is_pressed() and event is InputEventKey or event is InputEventJoypadButton):
		if (event.is_action_pressed("exit")):
			load_next()
		elif (!playing):
			playing = true
			start_fade()

func start_fade() -> void:
	anim.animation_set_next("fade_out", "title_card_fade")
	anim.stop()
	anim.play("fade_out")
	await anim.animation_finished
	load_next()

func load_next() -> void:
	RoomManager.load_room_with_fade(FirstRoom)
	Gamestate.options.start_menu = false;
