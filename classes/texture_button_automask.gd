class_name TextureButtonAutomask extends TextureButton

func _ready() -> void:
	if texture_normal:
		var image := texture_normal.get_image()
		var bitmap := BitMap.new()
		bitmap.create_from_image_alpha(image)
		self.texture_click_mask = bitmap
