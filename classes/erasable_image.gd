class_name ErasableImage extends Sprite2D

@export var tex: Texture2D

var child: Sprite2D
var mask: DrawableTexture2D

func _init(_tex: Texture2D = null) -> void:
	tex = _tex

func _ready() -> void:
	child = Sprite2D.new()
	child.texture = tex
	
	mask = DrawableTexture2D.new()
	mask.setup(tex.get_width(), tex.get_height(), DrawableTexture2D.DRAWABLE_FORMAT_RGBA8)
	#bitmap.create_from_image_alpha(image)
	
	self.texture = mask
	self.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
	
	self.add_child(child)

func _unhandled_input(event: InputEvent) -> void:
	pass
