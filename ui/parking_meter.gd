extends Control

const SECS_PER_COIN: int = 10

@export var meter_screen: Label
@export var coins_label: Label

@export var parking_meter_anim: AnimatedSprite2D
@export var hand_deposit_anim: AnimatedSprite2D

@export var add_time_button: TextureButton
@export var go_button: TextureButton
@export var add_time_area: ClickableArea2D

var current_inserted_coins: int = 0
var current_meter_time: int = 0

func _ready() -> void:
	var coins_left: int = Errands.coins - current_inserted_coins
	coins_label.text = "%d" % coins_left
	SFX.play_sound(preload("res://assets/sounds/footstep1.wav"))

func _on_start_button_pressed() -> void:
	SFX.play_sound(preload("res://assets/sounds/ui/confirm1.wav"))
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
	if hand_deposit_anim.is_playing(): return
	SFX.play_sound(preload("res://assets/sounds/Coinslot.wav"))
	hand_deposit_anim.play("deposit")
	parking_meter_anim.play("deposit")
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
	coins_label.text = "%d" % coins_left

func _on_parking_meter_anim_animation_finished() -> void:
	if (parking_meter_anim.animation == "runup"):
		hand_deposit_anim.visible = true
		add_time_button.visible = true
		add_time_area.visible = true
		go_button.visible = true
		coins_label.visible = true
		meter_screen.visible = true
		hand_deposit_anim.play("show_hands")
