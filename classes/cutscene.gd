class_name Cutscene extends Control

func end_cutscene(..._args: Array) -> void:
	Scenes.goto_next()
