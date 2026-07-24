extends Node

var current_scene: Node = null
var next: PackedScene = null

func _ready() -> void:
	var root := get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1)

func load_by_name(path: String) -> PackedScene:
	var res := ResourceLoader.load(path, "PackedScene")
	
	if res is not PackedScene:
		push_error("passed resource ", path , " is not a packed scene!")
		return null
	
	var scene: PackedScene = res
	if not scene:
		push_error("packed scene was null!")
		return null
		
	return scene

func goto_by_name(path: String) -> void:
	var scene: PackedScene = load_by_name(path)
	_deferred_goto.call_deferred(scene)

func goto_next() -> void:
	if next:
		goto(next)
	else:
		push_error("called goto_next() with no Scenes.next set")

func goto(scene: PackedScene) -> void:
	_deferred_goto.call_deferred(scene)

func _deferred_goto(scene: PackedScene) -> void:
	current_scene.free()
	
	current_scene = scene.instantiate()
	
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
