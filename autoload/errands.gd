extends Node

var selected_errands: Dictionary[StringName, bool] # bool is whether completed
var current_errand_id: StringName
var current_errand_packed_scene: PackedScene

var coins: int = 20
var meter_time: int = 0
var meter_running: bool = false

func reset_errands() -> void:
	var number_of_errands := randi_range(3, 5)
	
	selected_errands.clear()
	
	var errand_ids := Config.ERRAND_DB.keys()
	errand_ids.shuffle()
	
	var id_slice := errand_ids.slice(0, number_of_errands)
	for id: StringName in id_slice:
		selected_errands[id] = false

func select(errand_id: StringName) -> void:
	var errand: ErrandInfo = Config.ERRAND_DB[errand_id]
	
	current_errand_id = errand_id
	current_errand_packed_scene = Scenes.load_by_name(errand.scene_file)
	
	Scenes.next = preload("res://ui/parking_meter.tscn")
	Scenes.goto_by_name("res://cutscenes/parking.tscn")

func start() -> void:
	Scenes.goto_by_name("res://ui/errand_runner.tscn")

func finish() -> void:
	self.selected_errands[self.current_errand_id] = true
	
	var done_with_errands: bool = false
	for errand_id: StringName in self.selected_errands:
		if self.selected_errands[errand_id]:
			done_with_errands = false
	
	if done_with_errands:
		pass # TODO: go to a win screen
	else:
		Scenes.goto_by_name("res://ui/errand_picker.tscn")

func _ready() -> void:
	reset_errands()
