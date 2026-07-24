class_name Errand extends Control

signal errand_finished

func finish_errand(..._args: Array) -> void:
	errand_finished.emit()
	Errands.finish()
