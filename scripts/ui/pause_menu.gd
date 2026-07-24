extends NinePatchRect

@onready var continue_button: Button = $PauseMenu/Continue/ContinueButton
@onready var options_button: Button = $PauseMenu/Options/OptionsButton
@onready var exit_button: Button = $PauseMenu/Exit/ExitButton
@onready var options_menu: NinePatchRect = $OptionsMenu

## SFX
@export var press1: AudioStream
@export var press2: AudioStream

func _ready() -> void:
	options_menu.hide()

func _input(event: InputEvent) -> void:
	if (event.is_action_released("exit")):
		_on_continue_pressed()
		get_viewport().set_input_as_handled()

func _on_continue_pressed() -> void:
	options_menu.hide()
	get_parent().hide()
	get_tree().paused = false

func _on_options_pressed() -> void:
	options_menu.visible = !options_menu.visible

func _on_exit_pressed() -> void:
	get_tree().quit()
