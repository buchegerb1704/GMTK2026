extends Control

func _ready() -> void:
	var errand_container: VBoxContainer = $Paper/ErrandContainer
	
	for errand_id: int in Errands.selected_errands:
		var errand: Dictionary = Errands.ERRANDS_DB[errand_id]
		
		var errand_option := Button.new()
		
		errand_option.text = errand["title"]
		errand_option.focus_mode = Control.FOCUS_ALL
		
		errand_option.pressed.connect(func() -> void: errand_selected(errand_id))
		errand_option.focus_entered.connect(func() -> void: errand_focused(errand_id))
		
		errand_option.mouse_entered.connect(errand_option.grab_focus)
		
		errand_container.add_child(errand_option)

func errand_focused(errand_id: int) -> void:
	var errand: Dictionary = Errands.ERRANDS_DB[errand_id]
	$ColorRect/ErrandDesc.text = errand["description"]

func errand_selected(errand_id: int) -> void:
	Errands.select(errand_id)
