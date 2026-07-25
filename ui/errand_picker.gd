extends Control

@export var errand_container: Container
@export var errand_desc: Label

func _ready() -> void:
	for errand_id: StringName in Errands.selected_errands:
		var errand: ErrandInfo = Config.ERRAND_DB[errand_id]
		
		var errand_option := Button.new()
		
		errand_option.text = errand.title
		errand_option.focus_mode = Control.FOCUS_ALL
		
		@warning_ignore_start("return_value_discarded")
		errand_option.pressed.connect(func() -> void: errand_selected(errand_id))
		errand_option.focus_entered.connect(func() -> void: errand_focused(errand_id))
		errand_option.mouse_entered.connect(errand_option.grab_focus)
		@warning_ignore_restore("return_value_discarded")
		
		errand_container.add_child(errand_option)

func errand_focused(errand_id: StringName) -> void:
	var errand: ErrandInfo = Config.ERRAND_DB[errand_id]
	errand_desc.text = errand.description

func errand_selected(errand_id: StringName) -> void:
	Errands.select(errand_id)
