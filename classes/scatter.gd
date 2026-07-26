class_name SpriteScatter

## Randomly scatters sprites inside a Control, guaranteeing every sprite is
## fully contained - rotation, scale, offset and "centered" are all accounted for.
## Only the sprite's position is touched.
##
## Placement uses Mitchell's best-candidate algorithm: for each sprite we throw
## `candidates` random darts and keep the one furthest from everything placed so
## far. It's ~10 lines, always terminates, and gives a pleasant blue-noise /
## Poisson-disc-ish spread. More candidates = more even, fewer = more clumpy.

const DEFAULT_CANDIDATES := 10

## Scatter plain Sprite2Ds inside `container`.
static func scatter_sprites(
		sprites: Array[Sprite2D],
		container: Control,
		padding: float = 0.0,
		candidates: int = DEFAULT_CANDIDATES,
		rng: RandomNumberGenerator = null) -> void:
	var nodes: Array[Node2D] = []
	var rects: Array[Rect2] = []
	for s in sprites:
		nodes.append(s)
		# Sprite2D.get_rect() already handles centered, offset, region and h/vframes.
		rects.append(s.get_rect() if s.texture != null else Rect2())
	_scatter(nodes, rects, container, padding, candidates, rng)

## Same, for AnimatedSprite2Ds. Uses the currently displayed frame for sizing.
static func scatter_animated_sprites(
		sprites: Array[AnimatedSprite2D],
		container: Control,
		padding: float = 0.0,
		candidates: int = DEFAULT_CANDIDATES,
		rng: RandomNumberGenerator = null) -> void:
	var nodes: Array[Node2D] = []
	var rects: Array[Rect2] = []
	for s in sprites:
		nodes.append(s)
		rects.append(_animated_sprite_rect(s))
	_scatter(nodes, rects, container, padding, candidates, rng)

static func _scatter(
		nodes: Array[Node2D],
		local_rects: Array[Rect2],
		container: Control,
		padding: float,
		candidates: int,
		rng: RandomNumberGenerator) -> void:
	if rng == null:
		rng = RandomNumberGenerator.new()
		rng.randomize()
	
	var area := container.get_global_rect().grow(-padding)
	var placed: Array[Vector2] = []  # centres of the sprites we've already put down
	
	for i in nodes.size():
		var node := nodes[i]
		
		# The sprite's axis-aligned bounds *relative to its own origin*, after
		# rotation and scale. Zeroing the origin leaves just the basis.
		var xform := node.get_global_transform()
		xform.origin = Vector2.ZERO
		var bounds: Rect2 = xform * local_rects[i]
		var centre_offset := bounds.get_center()  # origin -> visual centre
		
		# Rectangle of legal origin positions: shrink the area by the sprite's
		# size, then shift it because the origin isn't necessarily the top-left.
		var legal := Rect2(area.position - bounds.position, area.size - bounds.size)
		
		if legal.size.x < 0.0 or legal.size.y < 0.0:
			# Sprite is bigger than the container: centre it and carry on.
			node.global_position = area.get_center() - centre_offset
			placed.append(area.get_center())
			continue
		
		var best := legal.position
		var best_score := -1.0
		for _c in maxi(candidates, 1):
			var p := Vector2(
				rng.randf_range(legal.position.x, legal.end.x),
				rng.randf_range(legal.position.y, legal.end.y))
			# Hack point: to enforce a hard minimum gap, skip candidates whose
			# score is below (min_gap * min_gap) and keep throwing darts.
			var score := _nearest_sqr_distance(p + centre_offset, placed)
			if score > best_score:
				best_score = score
				best = p
		
		node.global_position = best
		print("placed: ", node, " at ", node.global_position)
		placed.append(best + centre_offset)


static func _animated_sprite_rect(sprite: AnimatedSprite2D) -> Rect2:
	var frames := sprite.sprite_frames
	if frames == null or not frames.has_animation(sprite.animation):
		return Rect2()
	var tex := frames.get_frame_texture(sprite.animation, sprite.frame)
	if tex == null:
		return Rect2()
	var size := Vector2(tex.get_size())
	var pos := sprite.offset
	if sprite.centered:
		pos -= size * 0.5
	return Rect2(pos, size)


static func _nearest_sqr_distance(point: Vector2, others: Array[Vector2]) -> float:
	var nearest := INF
	for o in others:
		nearest = minf(nearest, point.distance_squared_to(o))
	return nearest
