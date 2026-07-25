extends Node

var selected_errands: Array[StringName] = []
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
	
	selected_errands = errand_ids.slice(0, number_of_errands)

func select(errand_id: StringName) -> void:
	var errand: ErrandInfo = Config.ERRAND_DB[errand_id]
	
	current_errand_id = errand_id
	current_errand_packed_scene = Scenes.load_by_name(errand.scene_file)
	
	Scenes.next = preload("res://ui/parking_meter.tscn")
	Scenes.goto_by_name("res://cutscenes/parking.tscn")

func start() -> void:
	Scenes.goto_by_name("res://ui/errand_runner.tscn")

func finish() -> void:
	Scenes.goto_by_name("res://ui/errand_picker.tscn")

func _ready() -> void:
	reset_errands()
