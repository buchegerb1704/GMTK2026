class_name ScrubTexture extends TextureRect

var mask_img: Image
var mask_tex: ImageTexture

var _alpha: PackedFloat32Array
var _w: int
var _h: int

var _original_mass: float = 0.0
var _remaining_mass: float = 0.0

var _dirty := false

var brush_screen_radius := 50.0
var scrub_strength := 0.6

func _brush_radius_texels() -> int:
	# Node is scaled uniformly; guard against zero.
	var sx: float = maxf(scale.x, 0.0001)
	return int(ceil(brush_screen_radius / sx))

signal scrubbed_clean(node: ScrubTexture)

func _init(tex: Texture2D = null) -> void:
	if tex:
		self.texture = tex

func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	_w = self.texture.get_width()
	_h = self.texture.get_height()

	var src := self.texture.get_image()
	_alpha = PackedFloat32Array()
	@warning_ignore("return_value_discarded")
	_alpha.resize(_w * _h)
	
	for y in _h:
		for x in _w:
			var a := src.get_pixel(x, y).a
			_alpha[y * _w + x] = a
			_original_mass += a
	_remaining_mass = _original_mass

	mask_img = Image.create(_w, _h, false, Image.FORMAT_RF)
	mask_img.fill(Color(1, 0, 0))
	mask_tex = ImageTexture.create_from_image(mask_img)
	
	var mat := ShaderMaterial.new()
	mat.shader = preload("res://shaders/scrub_texture.gdshader")
	
	mat.set_shader_parameter("graffiti", self.texture)
	mat.set_shader_parameter("mask", mask_tex)
	
	material = mat

func try_scrub_global(global_pos: Vector2) -> bool:
	var local := get_global_transform().affine_inverse() * global_pos
	
	var x := int(local.x)
	var y := int(local.y)
	
	if x < 0 or y < 0 or x >= _w or y >= _h:
		return false
	
	var idx := y * _w + x
	
	if _alpha[idx] <= 0.0:
		return false
	
	var effective := _alpha[idx] * mask_img.get_pixel(x, y).r
	if effective < 0.05:
		return false
	
	scrub_at(local)
	
	return true

func scrub_at(pos: Vector2) -> void:
	var cx := int(pos.x)
	var cy := int(pos.y)

	var r := _brush_radius_texels()
	if r < 1:
		r = 1
	var rf := float(r)

	for y in range(max(0, cy - r), min(_h, cy + r)):
		for x in range(max(0, cx - r), min(_w, cx + r)):
			var idx := y * _w + x
			var orig_a := _alpha[idx]
			if orig_a <= 0.0:
				continue
			var d := Vector2(x - cx, y - cy).length()
			if d <= rf:
				var falloff := 1.0 - (d / rf)
				var cur := mask_img.get_pixel(x, y).r
				var new_val: float = max(0.0, cur - scrub_strength * falloff)
				var delta := cur - new_val
				if delta > 0.0:
					mask_img.set_pixel(x, y, Color(new_val, 0, 0))
					_remaining_mass -= delta * orig_a
	_dirty = true

func _process(_delta: float) -> void:
	if _dirty:
		mask_tex.update(mask_img)
		_dirty = false
		if _remaining_mass <= _original_mass * 0.01:
			scrubbed_clean.emit(self)
