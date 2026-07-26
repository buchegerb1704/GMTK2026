extends Errand

@export var GROCERY_DB: Dictionary[String, Texture2D]
@export var grocery_control: Control

var grocery_items: Array[String]
var list_items_remaining: int
var list_entry_count := 0

func add_to_list(list_item_text: String) -> Label:
# sorry this is AWFUL
	list_item_text = "[ ] " + list_item_text.replace("_", " ")
	var label: Label

	@warning_ignore_start("unsafe_property_access")
	match list_entry_count:
		0:
			label = $ListHand/GroceryListItem1
		1:
			label = $ListHand/GroceryListItem2
		2:
			label = $ListHand/GroceryListItem3
		_:
			print("death, idk")
	@warning_ignore_restore("unsafe_property_access")

	list_entry_count += 1
	label.text = list_item_text
	return label

func _ready() -> void:
	grocery_items = GROCERY_DB.keys()
	grocery_items.shuffle()

	const grocery_list_length := 3 # via max design doc
	const shelf_row_length := 7 # via max design doc
	const shelf_column_length := 6 # via max design doc
	
	list_items_remaining = grocery_list_length

	var grocery_list: Dictionary[String, Label] = {}
	var grocery_shelf_items: Array[GroceryShelfItem] = []
	@warning_ignore("return_value_discarded")
	grocery_shelf_items.resize(shelf_row_length * shelf_column_length)

	# generate grocery list
	for i in grocery_list_length:
		grocery_list.get_or_add(grocery_items[i])
		grocery_list[grocery_items[i]] = add_to_list(grocery_items[i])
		var shelf_item := GroceryShelfItem.new()
		shelf_item.grocery_name = grocery_items[i]
		shelf_item.on_list = true
		grocery_shelf_items[i] = shelf_item

	# generate grocery fodder
	for i in range(grocery_list.size(), grocery_shelf_items.size()):
		var shelf_item := GroceryShelfItem.new()
		shelf_item.grocery_name = grocery_items[
				randi_range(grocery_list.size(), grocery_items.size() - 1)
			]
		grocery_shelf_items[i] = shelf_item

	grocery_shelf_items.shuffle()

	var column_position_offset := 0
	var grocery_shelf_index := 0

	for column in shelf_column_length:
		var row_position_offset := 60
		for row in shelf_row_length:
			var shelf_item := grocery_shelf_items[grocery_shelf_index]
			shelf_item.texture_normal = GROCERY_DB.get(shelf_item.grocery_name)
			shelf_item.ignore_texture_size = true
			shelf_item.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
			var random_size := randi_range(75, 90)
			shelf_item.set_size(Vector2(random_size, random_size))
			shelf_item.rotation_degrees = randi_range(-15, 15)
			shelf_item.set_position(Vector2(row_position_offset, column_position_offset))
			@warning_ignore("return_value_discarded")
			shelf_item.pressed.connect(func() -> void:
				if shelf_item.on_list:
					print("correct!")
					@warning_ignore("unsafe_call_argument")
					SFX.play_sound([
								preload("res://assets/sounds/bagrustle.wav"),
								preload("res://assets/sounds/bagrustle2.wav"),
								preload("res://assets/sounds/bagrustle3.wav")
							].pick_random(),
						func() -> void: 
							if (list_items_remaining == 0):
								self.finish_errand()
					)
					grocery_list[shelf_item.grocery_name].text = grocery_list[shelf_item.grocery_name].text.replace("[ ]", "[X]")
					shelf_item.disabled = true
					var tween_fade_away := create_tween()
					@warning_ignore("return_value_discarded")
					tween_fade_away.tween_property(shelf_item, "modulate", Color.TRANSPARENT, 0.3).set_trans(Tween.TRANS_BOUNCE)
					list_items_remaining -= 1
				else:
					# TODO lock control for 3sec
					SFX.play_sound(preload("res://assets/sounds/incorrectbuzzer.wav"))
					print("bad!!!!")
			)
			$GroceryControl.add_child(shelf_item)
			row_position_offset += 120
			grocery_shelf_index += 1
		column_position_offset += 90
