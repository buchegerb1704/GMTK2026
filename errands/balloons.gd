extends Errand

## Scatters the balloon sprites randomly inside the visible screen area,
## keeping every sprite fully on-screen, then gives each one its own
## subtle bobbing + swaying loop.

@export var balloon_parent: Node
@export var hand: AnimatedSprite2D

@export var pop_sounds: Array[AudioStream]

@export_group("Placement")
## Minimum gap between a sprite's edge and the edge of the screen.
@export var screen_margin: float = 24.0
## Preferred distance between balloon origins. Best-effort: if a spot that
## far from its neighbours can't be found, the roomiest candidate is used.
@export var min_separation: float = 160.0
@export var placement_attempts: int = 60

@export_group("Bobbing")
@export var bob_distance_min: float = 4.0
@export var bob_distance_max: float = 12.0
@export var bob_duration_min: float = 2.0
@export var bob_duration_max: float = 3.5

@export_group("Swaying")
@export var sway_degrees_min: float = 0.8
@export var sway_degrees_max: float = 2.5
@export var sway_duration_min: float = 2.5
@export var sway_duration_max: float = 4.5

func _ready() -> void:
	scatter()


func scatter() -> void:
	var balloons := _balloons()
	SpriteScatter.scatter_sprites(balloons, self)
	for sprite in balloons:
		_animate(sprite)
		var area2d: Area2D = sprite.get_child(0)
		area2d.input_event.connect(_on_clickable_input_event.bind(sprite))


func pop_balloon(balloon: Sprite2D) -> void:
	var current_ballons := balloon_parent.get_child_count()
	SFX.play_sound(pop_sounds.pick_random())
	balloon.queue_free()
	current_ballons -= 1
	if current_ballons == 0:
		finish_errand()


func _balloons() -> Array[Sprite2D]:
	var result: Array[Sprite2D] = []
	for child in balloon_parent.get_children():
		if child is Sprite2D:
			result.append(child)
	return result


func _animate(sprite: Sprite2D) -> void:
	var bob := randf_range(bob_distance_min, bob_distance_max)
	var bob_time := randf_range(bob_duration_min, bob_duration_max)
	var base: Vector2 = sprite.position
	sprite.position.y = base.y - bob
	
	var bob_tween := sprite.create_tween().set_loops()
	
	@warning_ignore_start("return_value_discarded")
	bob_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	bob_tween.tween_property(sprite, "position:y", base.y + bob, bob_time)
	bob_tween.tween_property(sprite, "position:y", base.y - bob, bob_time)
	bob_tween.custom_step(randf() * bob_time * 2.0) # randomize start times
	@warning_ignore_restore("return_value_discarded")
	
	var sway := deg_to_rad(randf_range(sway_degrees_min, sway_degrees_max))
	var sway_time := randf_range(sway_duration_min, sway_duration_max)
	var direction := 1.0 if randf() < 0.5 else -1.0
	sprite.rotation = -sway * direction
	
	var sway_tween := sprite.create_tween().set_loops()
	
	@warning_ignore_start("return_value_discarded")
	sway_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	sway_tween.tween_property(sprite, "rotation", sway * direction, sway_time)
	sway_tween.tween_property(sprite, "rotation", -sway * direction, sway_time)
	sway_tween.custom_step(randf() * sway_time * 2.0)
	@warning_ignore_restore("return_value_discarded")


func _on_clickable_input_event(viewport: Node, event: InputEvent, shape_idx: int, balloon: Sprite2D) -> void:
	if event is not InputEventMouseButton:
		return
	
	var button: InputEventMouseButton = event
	if button.pressed && button.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		hand.play("poke")
		hand.animation_finished.connect(pop_balloon.bind(balloon), ConnectFlags.CONNECT_ONE_SHOT)
