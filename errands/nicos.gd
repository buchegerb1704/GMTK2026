extends Errand

@export var nicos_audio: AudioStreamPlayer
@export var punch_audio: AudioStreamPlayer

@export var punches: Array[AudioStreamWAV]
@export var steps: Array[AudioStreamWAV]
@export var nicos_dizzy: AudioStreamWAV
@export var nicos_defeat: Array[AudioStreamWAV]
@export var nicos_pain: Array[AudioStreamWAV]

@export var nicos_anim: AnimatedSprite2D
@export var a_button_anim: AnimatedSprite2D
@export var d_button_anim: AnimatedSprite2D

var _punches_required: int = -1

func _ready() -> void:
	punch_audio.stream = steps.pick_random()
	punch_audio.play()
	a_button_anim.visible = false
	d_button_anim.visible = false
	_punches_required = randi_range(5, 15)

func _input(event: InputEvent) -> void:
	if nicos_anim.is_playing(): return
	if event.is_action_released("punch_left"):
		nicos_anim.play("punch_left")
		a_button_anim.play("button_a")
		_hurt_nicos()
	elif event.is_action_released("punch_right"):
		nicos_anim.play("punch_right")
		d_button_anim.play("button_d")
		_hurt_nicos()

func _hurt_nicos() -> void:
	SFX.play_sound(punches.pick_random())
	SFX.play_sound(nicos_pain.pick_random())
	_punches_required = _punches_required - 1

func _on_nicos_anim_animation_finished() -> void:
	if (nicos_anim.animation == "default"):
		a_button_anim.visible = true
		d_button_anim.visible = true
	elif (nicos_anim.animation == "punch_left" or nicos_anim.animation == "punch_right") and _punches_required == 0:
		nicos_anim.play("dizzy_windup")
		SFX.play_sound(nicos_dizzy)
	elif (nicos_anim.animation == "dizzy_windup"):
		SFX.play_sound(nicos_defeat.pick_random())
		nicos_anim.play("dizzy")
	elif (nicos_anim.animation == "dizzy"):
		self.finish_errand()
