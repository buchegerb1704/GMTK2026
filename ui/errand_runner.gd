extends Control

const TOW_RISK_PER_SECOND: float = 0.15

var errand_node: Errand

@export var errand_container: Control
@export var meter_timer: Label

func _ready() -> void:
	errand_node = Errands.current_errand_packed_scene.instantiate()
	
	errand_container.add_child(errand_node)
	
	meter_timer.text = str(Errands.meter_time)
	Errands.meter_running = true

func _on_timer_timeout() -> void:
	if Errands.meter_running:
		if Errands.meter_time > 0:
			Errands.meter_time -= 1
			meter_timer.text = str(Errands.meter_time)
			if Errands.meter_time == 0:
				var tween := create_tween().set_loops()
				@warning_ignore_start("return_value_discarded")
				tween.tween_property(meter_timer.label_settings, "font_color", Color(Color.RED), 0.25)
				tween.tween_property(meter_timer.label_settings, "font_color", Color(Color.WHITE), 0.25)
				@warning_ignore_restore("return_value_discarded")
		else:
			var roll := randf()
			
			if roll < TOW_RISK_PER_SECOND:
				print("you rolled a %f (needed above %f)... you got towed!" % [roll, TOW_RISK_PER_SECOND])
				Scenes.next = preload("res://ui/main_menu.tscn")
				Scenes.goto_by_name("res://cutscenes/towed.tscn")
			else:
				print("you rolled a %f (needed above %f)... you get away with it for now..." % [roll, TOW_RISK_PER_SECOND])
