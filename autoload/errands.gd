extends Node

var selected_errands: Dictionary[StringName, bool] # bool is whether completed
var current_errand_id: StringName
var current_errand_scene_file: String
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
	current_errand_scene_file = errand.scene_file
	@warning_ignore("return_value_discarded")
	ResourceLoader.load_threaded_request(current_errand_scene_file, "PackedScene")
	
	Scenes.next = preload("res://ui/parking_meter.tscn")
	Scenes.goto_by_name("res://cutscenes/parking.tscn")

func start() -> void:
	current_errand_packed_scene = ResourceLoader.load_threaded_get(current_errand_scene_file)
	Scenes.goto_by_name("res://ui/errand_runner.tscn")

func finish() -> void:
	self.selected_errands[self.current_errand_id] = true
	
	var done_with_errands: bool = true
	for errand_id: StringName in self.selected_errands:
		if self.selected_errands[errand_id] == false:
			done_with_errands = false
	
	if done_with_errands:
		Scenes.goto_by_name("res://ui/win_screen.tscn")
	else:
		Scenes.goto(preload("res://cutscenes/drive_off.tscn"))

func _ready() -> void:
	reset_errands()
