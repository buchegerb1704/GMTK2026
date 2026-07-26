extends Errand

@export var CLOTHES_DB: Array[LaundryItem]
@export var washers: Dictionary[LaundryItem.CLOTH_COLOR, ClickableArea2D]
@export var throw_sounds: Array[AudioStream]

var clothes: Array[LaundryItem]
var current_item: Sprite2D

var can_click: bool = true

func _ready() -> void:
	@warning_ignore_start("return_value_discarded")
	($Blue as ClickableArea2D).clicked.connect(_on_blue_washing_pressed)
	($White as ClickableArea2D).clicked.connect(_on_white_washing_pressed)
	($Red as ClickableArea2D).clicked.connect(_on_red_washing_pressed)
	@warning_ignore_restore("return_value_discarded")
	
	var number_of_clothes := randi_range(9, 15)
	
	for x in number_of_clothes:
		clothes.push_back(CLOTHES_DB.pick_random())
	
	spawn_front()

func spawn_front() -> void:
	var new_item: LaundryItem = clothes.front()
	var item_sprite := Sprite2D.new()
	item_sprite.texture = new_item.texture
	item_sprite.scale = Vector2(0.5, 0.5)
	self.add_child(item_sprite)
	item_sprite.position = ($Marker2D as Marker2D).position + Vector2(0, 300)
	var tween := get_tree().create_tween()
	
	@warning_ignore_start("return_value_discarded")
	tween.tween_property(item_sprite, "position", ($Marker2D as Marker2D).position, 0.5)
	tween.tween_callback(reset_click)
	@warning_ignore_restore("return_value_discarded")
	
	current_item = item_sprite
	reset_click()

func throw_item(color: LaundryItem.CLOTH_COLOR) -> void:
	can_click = false
	var item: LaundryItem = clothes.front()
	
	@warning_ignore("unsafe_cast")
	SFX.play_sound(throw_sounds.pick_random() as AudioStream)
	
	var tween := get_tree().create_tween()
	@warning_ignore_start("return_value_discarded")
	tween.tween_property(current_item, "global_position", washers[color].global_position, 1)
	tween.parallel().tween_property(current_item, "scale", Vector2(0.2, 0.2), 1)
	tween.parallel().tween_property(current_item, "rotation", 5, 1)
		
	if color == item.color:
		tween.tween_callback(item_correct)
	else:
		tween.tween_callback(item_wrong)
	@warning_ignore_restore("return_value_discarded")

func item_correct() -> void:
	current_item.queue_free()
	clothes.pop_front()
	
	if clothes.is_empty():
		finish_errand()
	else:
		spawn_front()

func item_wrong() -> void:
	print("wrong")
	var tween := get_tree().create_tween()
	
	@warning_ignore_start("return_value_discarded")
	tween.tween_property(current_item, "global_position", ($Marker2D as Marker2D).position, 1)
	tween.tween_property(current_item, "scale", Vector2(0.5, 0.5), 1)
	tween.parallel().tween_property(current_item, "rotation", 0, 1)
	tween.tween_callback(reset_click)
	@warning_ignore_restore("return_value_discarded")

func reset_click() -> void:
	can_click = true

func _on_blue_washing_pressed() -> void:
	if can_click:
		throw_item(LaundryItem.CLOTH_COLOR.Blue)

func _on_white_washing_pressed() -> void:
	if can_click:
		throw_item(LaundryItem.CLOTH_COLOR.White)

func _on_red_washing_pressed() -> void:
	if can_click:
		throw_item(LaundryItem.CLOTH_COLOR.Red)
