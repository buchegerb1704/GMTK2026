class_name ScrubTexture extends Sprite2D

signal scrubbed_clean(node: ScrubTexture)

const MASK_MAX_DIM := 128
const CLEAN_THRESHOLD := 0.01
const MAX_STEPS := 64

var brush_screen_radius := 50.0
var scrub_strength := 0.08

var _alpha := PackedByteArray()
var _mask := PackedByteArray()
var _w: int
var _h: int
var _mask_scale := 1.0
var _original_ink := 0
var _remaining_ink := 0

var _mask_img: Image
var _mask_tex: ImageTexture

func _init(tex: Texture2D = null) -> void:
	if tex:
		texture = tex

func _ready() -> void:
	centered = false
	
	var src := texture.get_image()
	if src.is_compressed():
		@warning_ignore("return_value_discarded")
		src.decompress()
	src.convert(Image.FORMAT_RGBA8)
	
	_mask_scale = minf(1.0, float(MASK_MAX_DIM) / maxi(src.get_width(), src.get_height()))
	_w = maxi(1, int(src.get_width() * _mask_scale))
	_h = maxi(1, int(src.get_height() * _mask_scale))
	src.resize(_w, _h, Image.INTERPOLATE_BILINEAR)
	var rgba := src.get_data()
	
	@warning_ignore("return_value_discarded")
	_alpha.resize(_w * _h)
	@warning_ignore("return_value_discarded")
	_mask.resize(_w * _h)
	_mask.fill(255)
	
	var alpha_total := 0
	for i in _alpha.size():
		var a := rgba[i * 4 + 3]
		_alpha[i] = a
		alpha_total += a
	
	_original_ink = alpha_total * 255
	_remaining_ink = _original_ink
	
	_mask_img = Image.create_from_data(_w, _h, false, Image.FORMAT_R8, _mask)
	_mask_tex = ImageTexture.create_from_image(_mask_img)
	
	var mat := ShaderMaterial.new()
	mat.shader = preload("res://shaders/alphamask.gdshader")
	mat.set_shader_parameter("base", texture)
	mat.set_shader_parameter("mask", _mask_tex)
	material = mat
	
	set_process(false)

func scrub(from: Vector2, to: Vector2) -> void:
	var a := to_local(from) * _mask_scale
	var b := to_local(to) * _mask_scale
	
	var radius := brush_screen_radius * _mask_scale / scale.x
	
	var steps := maxi(a.distance_to(b) / radius, 1)
	for i in range(1, steps + 1):
		_stamp(a.lerp(b, float(i) / steps), radius)

func _stamp(centre: Vector2, radius: float) -> void:
	var cx := int(centre.x)
	var cy := int(centre.y)
	var r := ceili(radius)
	var r_sqr := r * r
	var bite := maxi(1, int(scrub_strength * 255.0))
	var changed := false

	# Loop the square around the brush. maxi/mini clip it to the mask, so a
	# brush that's off the sprite entirely just gives an empty loop.
	for y in range(maxi(0, cy - r), mini(_h, cy + r + 1)):
		var dy := y - cy
		var row := y * _w
		for x in range(maxi(0, cx - r), mini(_w, cx + r + 1)):
			var dx := x - cx
			if dx * dx + dy * dy > r_sqr:
				continue  # square's corners, outside the circle
			
			var idx := row + x
			var ink := _alpha[idx]
			var left := _mask[idx]
			if ink == 0 or left == 0:
				continue  # nothing painted here, or already wiped
			
			var next := maxi(0, left - bite)
			_mask[idx] = next
			_remaining_ink -= (left - next) * ink
			changed = true
	
	if changed:
		set_process(true)

func _process(_delta: float) -> void:
	set_process(false)
	_mask_img.set_data(_w, _h, false, Image.FORMAT_R8, _mask)
	_mask_tex.update(_mask_img)
	if _remaining_ink <= int(_original_ink * CLEAN_THRESHOLD):
		scrubbed_clean.emit(self)
