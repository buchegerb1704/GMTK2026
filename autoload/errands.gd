extends Node

const ERRANDS_DB = {
	0: {
		"title":       "test 0 name",
		"description": "test 0 description",
		"scene": "res://errands/test_errand.tscn",
	},
	1: {
		"title":       "test 1 name",
		"description": "test 1 description",
		"scene": "res://errands/test_errand.tscn",
	},
	2: {
		"title":       "test 2 name",
		"description": "test 2 description",
		"scene": "res://errands/test_errand.tscn",
	},
	3: {
		"title":       "test 3 name",
		"description": "test 3 description",
		"scene": "res://errands/test_errand.tscn",
	},
	4: {
		"title":       "test 4 name",
		"description": "test 4 description",
		"scene": "res://errands/test_errand.tscn",
	},
	5: {
		"title":       "test 5 name",
		"description": "test 5 description",
		"scene": "res://errands/test_errand.tscn",
	},
	6: {
		"title":       "test 6 name",
		"description": "test 6 description",
		"scene": "res://errands/test_errand.tscn",
	},
	7: {
		"title":       "test 7 name",
		"description": "test 7 description",
		"scene": "res://errands/test_errand.tscn",
	},
}

var selected_errands: Array = []
var current_errand_id: int
var current_errand_packed_scene: PackedScene

var coins: int = 20
var meter_time: int = 0
var meter_running: bool = false

func reset_errands() -> void:
	var number_of_errands := randi_range(3, 5)
	
	selected_errands.clear()
	
	var errand_ids := range(ERRANDS_DB.size())
	errand_ids.shuffle()
	
	selected_errands = errand_ids.slice(0, number_of_errands)

func select(errand_id: int) -> void:
	var errand: Dictionary = ERRANDS_DB[errand_id]
	var scene_path: String = errand["scene"]
	
	current_errand_id = errand_id
	current_errand_packed_scene = Scenes.load_by_name(scene_path)
	
	Scenes.next = preload("res://ui/parking_meter.tscn")
	Scenes.goto_by_name("res://cutscenes/parking.tscn")

func start() -> void:
	Scenes.goto_by_name("res://ui/errand_runner.tscn")

func finish() -> void:
	Scenes.goto_by_name("res://ui/errand_picker.tscn")

func _ready() -> void:
	reset_errands()
