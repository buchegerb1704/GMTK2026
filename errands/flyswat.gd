extends Errand

@export var fly_swatter_anim: AnimatedSprite2D
@export var fly_swatter_area: Area2D
@export var fly_scene: PackedScene

var _fly_count: int

func _ready() -> void:
	_fly_count = randi_range(5,15)
	for n in _fly_count:
		var fly_node: Node2D = fly_scene.instantiate()
		self.add_child(fly_node)

func _input(event: InputEvent) -> void:
	if fly_swatter_anim.is_playing(): return
	if event is InputEventMouseButton:
		fly_swatter_anim.play("swat_down")

func _on_fly_swatter_anim_animation_finished() -> void:
	if fly_swatter_anim.animation == "swat_down":
		_detect_fly_collisions()
		fly_swatter_anim.play("swat_up")
		if (_fly_count <= 0):
			self.finish_errand()

func _detect_fly_collisions() -> void:
	var flies: Array[Node2D] = fly_swatter_area.get_overlapping_bodies()
	for fly in flies:
		var anim: AnimatedSprite2D = fly.get_node("FlyAnim")# fly.get_child(0)
		if (anim != null and anim.animation == "default"):
			anim.play("splat")
			_fly_count = _fly_count - 1
