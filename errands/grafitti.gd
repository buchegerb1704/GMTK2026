extends Errand

@export var GRAFFITI_DB: Array[Texture2D]
@export var graffiti_container: Control

func _ready() -> void:
	var number_of_graffiti := randi_range(3, 5)
	
	var graffiti_pool := GRAFFITI_DB.duplicate()
	graffiti_pool.shuffle()
	
	var selected_graffiti := graffiti_pool.slice(0, number_of_graffiti)
	
	# TODO: make this a random selection, not all
	#for x: Texture2D in selected_graffiti:
		#var new_graffiti := ErasableImage.new(x)
		#
		#graffiti_container.add_child(new_graffiti)
