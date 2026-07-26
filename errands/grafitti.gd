extends Errand

## Cap on a single graffiti's size, as a fraction of the play area.
const MAX_FRAC := 0.6

@export var GRAFFITI_DB: Array[Texture2D]

var _scrubbers: Array[ScrubTexture] = []
var _prev_mouse := Vector2.INF

func _ready() -> void:
	var pool := GRAFFITI_DB.duplicate()
	pool.shuffle()

	for tex: Texture2D in pool.slice(0, randi_range(3, 5)):
		var g := ScrubTexture.new(tex)
		@warning_ignore("return_value_discarded")
		g.scrubbed_clean.connect(_on_scrubbed_clean)
		add_child(g)
		_scrubbers.append(g)
	
	for g in _scrubbers:
		var tex_size := g.texture.get_size()
		# Fit each piece inside MAX_FRAC of the play area so several can
		# coexist, never upscaling past native resolution, then vary within
		# that budget.
		var fit := minf(1.0, minf(
			size.x * MAX_FRAC / tex_size.x,
			size.y * MAX_FRAC / tex_size.y))
		g.scale = Vector2.ONE * fit * randf_range(0.75, 1.0)
		g.rotation = randf_range(-0.25, 0.25)
	
	# Scatter measures each sprite's current transform, so it has to run after
	# scale and rotation are set. assign() converts the typed array in place.
	var sprites: Array[Sprite2D] = []
	sprites.assign(_scrubbers)
	SpriteScatter.scatter_sprites(sprites, self)

func _process(_delta: float) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_prev_mouse = Vector2.INF
		return
	
	var pos := get_global_mouse_position()
	if _prev_mouse.is_finite():
		for g in _scrubbers:
			g.scrub(_prev_mouse, pos)
	_prev_mouse = pos

func _on_scrubbed_clean(node: ScrubTexture) -> void:
	_scrubbers.erase(node)
	node.queue_free()
	if _scrubbers.is_empty():
		finish_errand()
