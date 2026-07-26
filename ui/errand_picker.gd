extends Control

@export var errand_container: Container
@export var errand_desc: Label

func _ready() -> void:
	for errand_id: StringName in Errands.selected_errands:
		var errand: ErrandInfo = Errands.ERRAND_DB[errand_id]
		var completed: bool = Errands.selected_errands[errand_id]
		
		var errand_option := Button.new()
		var rich_text := RichTextLabel.new()
		
		errand_option.text = " " #errand.title
		errand_option.focus_mode = Control.FOCUS_ALL
		errand_option.disabled = completed
		
		@warning_ignore_start("return_value_discarded")
		errand_option.pressed.connect(func() -> void: errand_selected(errand_id))
		errand_option.focus_entered.connect(func() -> void: errand_focused(errand_id))
		errand_option.mouse_entered.connect(errand_option.grab_focus)
		@warning_ignore_restore("return_value_discarded")
		
#		rich_text.add_child(errand_option)
		errand_option.add_child(rich_text)
		
		if (completed):
			rich_text.bbcode_enabled = true
			rich_text.text = "[s]"
		
		rich_text.text += errand.title
		rich_text.add_theme_color_override("default_color", Color())
		rich_text.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_KEEP_SIZE)
		rich_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
		rich_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		rich_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

		errand_container.add_child(errand_option)

func errand_focused(errand_id: StringName) -> void:
	var errand: ErrandInfo = Errands.ERRAND_DB[errand_id]
	errand_desc.text = errand.description

func errand_selected(errand_id: StringName) -> void:
	Errands.select(errand_id)
