extends Errand

@export var GRAFFITI_DB: Array[Texture2D]
@export var graffiti_container: Control

var _scrubbers: Array[ScrubTexture] = []

func _ready() -> void:
	var number_of_graffiti := randi_range(3, 5)
	
	var graffiti_pool := GRAFFITI_DB.duplicate()
	graffiti_pool.shuffle()
	
	var selected_graffiti := graffiti_pool.slice(0, number_of_graffiti)
	
	for x: Texture2D in selected_graffiti:
		var new_graffiti := ScrubTexture.new(x)
		@warning_ignore("return_value_discarded")
		new_graffiti.scrubbed_clean.connect(_on_scrubbed_clean)
		graffiti_container.add_child(new_graffiti)
		_scrubbers.append(new_graffiti)
	
	await get_tree().process_frame
	for g in _scrubbers:
		_place_graffiti(g)

func _place_graffiti(g: ScrubTexture) -> void:
	var tex_size := g.texture.get_size()
	
	# Pin to top-left anchors so our explicit position/size aren't recomputed
	# by the layout system.
	g.set_anchors_preset(Control.PRESET_TOP_LEFT)
	g.size = tex_size
	g.pivot_offset = tex_size * 0.5
	
	var cont := graffiti_container.size
	
	# Fit the graffiti to a fraction of the container so several can coexist.
	# Cap the scale so the largest dimension is at most `max_frac` of the
	# corresponding container dimension.
	var max_frac := 0.65
	var fit_scale := minf(
		cont.x * max_frac / tex_size.x,
		cont.y * max_frac / tex_size.y
	)
	fit_scale = minf(fit_scale, 1.0)  # never upscale past native resolution
	var s := fit_scale * randf_range(0.75, 1.0)  # vary within the fitted budget
	g.scale = Vector2(s, s)
	g.rotation = randf_range(-0.25, 0.25)
	
	# Choose a center such that the rotated, scaled bounding box stays inside.
	var half := _rotated_half_extent(tex_size * s, g.rotation)
	var center := Vector2(
		_safe_rand(half.x, cont.x - half.x),
		_safe_rand(half.y, cont.y - half.y)
	)
	
	# In Godot, `scale` pivots about `pivot_offset` measured in UNSCALED local
	# coordinates, so the visual center sits at `position + pivot_offset`
	# (not pivot_offset * scale). Invert that to place the center where we want.
	g.position = center - g.pivot_offset

# randf_range but tolerant of an inverted/empty range: if lo >= hi the axis can't
# fit, so center it instead of pinning to an edge.
func _safe_rand(lo: float, hi: float) -> float:
	if lo >= hi:
		return (lo + hi) * 0.5
	return randf_range(lo, hi)

func _rotated_half_extent(scaled_size: Vector2, rot: float) -> Vector2:
	var ext_x := absf(scaled_size.x * cos(rot)) + absf(scaled_size.y * sin(rot))
	var ext_y := absf(scaled_size.x * sin(rot)) + absf(scaled_size.y * cos(rot))
	return Vector2(ext_x, ext_y) * 0.5

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_movement := event as InputEventMouseMotion
		if mouse_movement:
			var ordered: Array[ScrubTexture] = _scrubbers.duplicate()
			ordered.reverse()  # reverse so topmost is first
			for scrubber in ordered:
				if scrubber.try_scrub_global(mouse_movement.global_position):
					break

func _on_scrubbed_clean(node: ScrubTexture) -> void:
	_scrubbers.erase(node)
	node.queue_free()
	if _scrubbers.is_empty():
		self.finish_errand()
