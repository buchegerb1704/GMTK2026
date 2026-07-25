extends Control

const SECS_PER_COIN: int = 15

@export var meter_screen: Label
@export var coins_label: Label

var current_inserted_coins: int = 0
var current_meter_time: int = 0

func _ready() -> void:
	var coins_left: int = Errands.coins - current_inserted_coins
	coins_label.text = "you have %d coins left" % coins_left

func _on_start_button_pressed() -> void:
	Errands.coins -= current_inserted_coins
	Errands.meter_time = current_meter_time
	Errands.start()

func _on_plus_button_pressed() -> void:
	if current_inserted_coins <= Errands.coins:
		add_coin()

func _on_minus_button_pressed() -> void:
	if current_inserted_coins > 0:
		remove_coin()

func add_coin() -> void:
	current_inserted_coins += 1
	current_meter_time = current_inserted_coins * SECS_PER_COIN
	update_meter_screen()

func remove_coin() -> void:
	current_inserted_coins -= 1
	current_meter_time = current_inserted_coins * SECS_PER_COIN
	update_meter_screen()

func update_meter_screen() -> void:
	@warning_ignore("integer_division")
	var dollars: int = current_inserted_coins / 4
	var cents: int = (current_inserted_coins % 4) * 25
	meter_screen.text = "$%d.%02d\n%d sec." % [dollars, cents, current_meter_time]
	
	var coins_left: int = Errands.coins - current_inserted_coins
	coins_label.text = "you have %d coins left" % coins_left
