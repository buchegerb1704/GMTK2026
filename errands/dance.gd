extends Errand

@export var NUM_MOVES: int = 7
@export var KEY_FRAMES: Dictionary[DANCE_DIRECTIONS, int]
@export var AUDIO_HITS: Array[AudioStream]
@export var demo_key: Sprite2D
@export var hit_player: AudioStreamPlayer2D
@export var sfx_player: AudioStreamPlayer2D
@export var guy: AnimatedSprite2D
@export var bg: AnimatedSprite2D

enum DANCE_DIRECTIONS { UP, DOWN, LEFT, RIGHT }

var dance_sequence: Array[DANCE_DIRECTIONS]
var dance_play: Array[DANCE_DIRECTIONS]

var win_sound := preload("res://assets/sound/applause.wav")
var lose_sound := preload("res://assets/sound/incorrectbuzzer.wav")

var current_step: int = 0

var can_input: bool

func _init() -> void:
	for x in range(NUM_MOVES):
		dance_sequence.push_back(randf_range(0, DANCE_DIRECTIONS.size()))

func _ready() -> void:
	demo_dance()

func demo_dance() -> void:
	can_input = false
	demo_key.visible = true
	guy.visible = false
	dance_play = dance_sequence.duplicate()
	next_key()

func play_game() -> void:
	current_step = 0
	can_input = true
	demo_key.visible = false
	guy.visible = true
	dance_play = dance_sequence.duplicate()

func next_key() -> void:
	demo_key.self_modulate = Color.WHITE
	
	if dance_play.is_empty():
		play_game()
	else:
		var next_move: DANCE_DIRECTIONS = dance_play.pop_front()
		show_key(next_move)

func show_key(key: DANCE_DIRECTIONS) -> void:
	demo_key.frame = KEY_FRAMES[key]
	
	var tween := demo_key.create_tween()
	@warning_ignore_start("return_value_discarded")
	tween.tween_property(demo_key, "scale", Vector2(1.25, 1.25), 0.025).set_ease(Tween.EASE_IN)
	tween.tween_property(demo_key, "scale", Vector2(1.0, 1.0), 0.6)
	tween.parallel().tween_property(demo_key, "self_modulate", Color(1, 1, 1, 0.9), 0.6).set_ease(Tween.EASE_IN)
	tween.tween_callback(next_key)
	@warning_ignore_restore("return_value_discarded")

func correct() -> void:
	hit_player.stream = AUDIO_HITS[current_step]
	hit_player.play()
	
	match current_step:
		0:
			bg.play("bg1")
			guy.play("dance1")
		1:
			bg.play("bg2")
			guy.play("dance2")
		2:
			bg.play("bg3")
			guy.play("dance3")
		3:
			bg.play("bg4")
			guy.play("dance4")
		4:
			bg.play("bg5")
			guy.play("dance5")
		5:
			bg.play("bg6")
			guy.play("dance6")
		6:
			bg.play("bg7")
			guy.play("dance7")
	
	current_step += 1
	
	if current_step == dance_sequence.size():
		can_input = false
		sfx_player.stream = win_sound
		sfx_player.play()
		sfx_player.finished.connect(finish_errand)

func failure() -> void:
	bg.play("bg1")
	bg.stop()
	guy.play("dance1")
	guy.visible = false
	sfx_player.stream = lose_sound
	sfx_player.play()
	demo_dance()

func _input(event: InputEvent) -> void:
	if !can_input:
		return
	
	var direction: DANCE_DIRECTIONS
	if event.is_action_pressed("ui_up"):
		direction = DANCE_DIRECTIONS.UP
	elif event.is_action_pressed("ui_down"):
		direction = DANCE_DIRECTIONS.DOWN
	elif event.is_action_pressed("ui_left"):
		direction = DANCE_DIRECTIONS.LEFT
	elif event.is_action_pressed("ui_right"):
		direction = DANCE_DIRECTIONS.RIGHT
	else:
		return
	
	if direction == dance_play.pop_front():
		correct()
	else:
		failure()
