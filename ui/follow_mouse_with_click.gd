extends "res://classes/follow_mouse.gd"

@export var hand_poke_anim: AnimatedSprite2D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		hand_poke_anim.play("default")
