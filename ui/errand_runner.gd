extends Control

const TOW_RISK_PER_SECOND: float = 0.15

var errand_node: Errand

func _ready() -> void:
	errand_node = Errands.current_errand_packed_scene.instantiate()
	
	$ErrandContainer.add_child(errand_node)
	
	$CornerMeter/MeterTimer.text = str(Errands.meter_time)
	Errands.meter_running = true

func _on_timer_timeout() -> void:
	if Errands.meter_running:
		if Errands.meter_time > 0:
			Errands.meter_time -= 1
			$CornerMeter/MeterTimer.text = str(Errands.meter_time)
		else:
			var roll := randf()
			
			if roll < TOW_RISK_PER_SECOND:
				print("you rolled a %f (needed above %f)... you got towed!" % [roll, TOW_RISK_PER_SECOND])
				Scenes.next = preload("res://ui/main_menu.tscn")
				Scenes.goto_by_name("res://cutscenes/towed.tscn")
			else:
				print("you rolled a %f (needed above %f)... you get away with it for now..." % [roll, TOW_RISK_PER_SECOND])
