class_name LaundryItem extends UserResource

enum CLOTH_COLOR { Red, White, Blue }

@export var color: CLOTH_COLOR
@export var texture: Texture2D
@export_range(0, 2, 0.1) var scale: float
