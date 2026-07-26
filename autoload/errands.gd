extends Node

var ERRAND_DB: Dictionary[StringName, ErrandInfo]

var selected_errands: Dictionary[StringName, bool] # bool is whether completed
var current_errand_id: StringName
var current_errand_scene_file: String
var current_errand_packed_scene: PackedScene

var meter_time: int = 0
var meter_running: bool = false

var coins: int

func _init() -> void:
	ERRAND_DB.assign(preload("res://config/errand_db_trim.tres").data)
	reset_errands()

func reset_errands() -> void:
	coins = Config.START_COINS
	
	var number_of_errands := Config.NUM_ERRANDS # randi_range(Config.ERRANDS_MIN, Config.ERRANDS_MAX)
	
	selected_errands.clear()
	
	var errand_ids := ERRAND_DB.keys()
	errand_ids.shuffle()
	
	var id_slice := errand_ids.slice(0, number_of_errands)
	for id: StringName in id_slice:
		selected_errands[id] = false

func select(errand_id: StringName) -> void:
	var errand: ErrandInfo = ERRAND_DB[errand_id]
	
	current_errand_id = errand_id
	current_errand_scene_file = errand.scene_file
	@warning_ignore("return_value_discarded")
	ResourceLoader.load_threaded_request(current_errand_scene_file, "PackedScene")
	
	Music.switch_gameplay()
	
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
		Scenes.goto_by_name("res://cutscenes/drive_off.tscn")
