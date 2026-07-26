extends StaticBody2D

@export var fly_anim: AnimatedSprite2D

@export var fly_audio: AudioStreamPlayer
@export var splat_sounds: Array[AudioStreamWAV]

var _velocity: Vector2 = Vector2(200,200)
var _coin: Array[float] = [-1,1]

func _ready() -> void:
	var speed_x: float = randf_range(200, 600) * _coin.pick_random()
	var speed_y: float = randf_range(200, 600) * _coin.pick_random()
	_velocity = Vector2(speed_x, speed_y)

func _physics_process(delta: float) -> void:
	var collision_info: KinematicCollision2D = move_and_collide(_velocity * delta)
	if collision_info:
		_velocity = _velocity.bounce(collision_info.get_normal())

func _on_fly_anim_animation_changed() -> void:
	if fly_anim.animation == "splat":
		_velocity = Vector2(0,0)
		fly_audio.stream = splat_sounds.pick_random()
		fly_audio.play()

func _on_fly_anim_animation_finished() -> void:
	if fly_anim.animation == "splat":
		self.queue_free()
