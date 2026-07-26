extends Control

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_start_button_pressed() -> void:
	Errands.reset_errands()
	Scenes.next = preload("res://ui/errand_picker.tscn")
	Scenes.goto(preload("res://cutscenes/driving.tscn"))

func _on_options_button_pressed() -> void:
	pass # Replace with function body.
