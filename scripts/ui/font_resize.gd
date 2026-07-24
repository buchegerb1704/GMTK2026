extends Control

var full_screen: int = 0

func _ready() -> void:
	if get_tree().get_root().size_changed.connect(window_resized):
		push_error("Failed to connect signal: get_root().size_changed.connect to window_resized")
	full_screen = DisplayServer.window_get_mode()
	call_deferred("set_children", self.get_children())

func _process(_delta: float) -> void:
	if (full_screen != DisplayServer.window_get_mode()):
		full_screen = DisplayServer.window_get_mode()
		call_deferred("window_resized")

func window_resized() -> void:
	check_children(self.get_children())

func set_children(children: Array[Node]) -> void:
	if (children == null or len(children) == 0): return
	for child in children:
		set_children(child.get_children())
		if (child is RichTextLabel or child is Button):
			save_font_size(child, child.get_parent())

func check_children(children: Array[Node]) -> void:
	if (children == null or len(children) == 0): return
	for child in children:
		check_children(child.get_children())
		if (child is RichTextLabel or child is Button):
			fix_font_size(child, child.get_parent())

# Recalculates font size to match current width of the screen
func fix_font_size(text_element: Control, _parent: Node) -> void:
	if (text_element.has_meta("fsize")):
		var font_override_default: float = text_element.get_meta("fsize")
		var parent_width_default: float = text_element.get_meta("pwidth")
		var parent_current_width: float = text_element.size.x
		
		var difference: float = parent_current_width / parent_width_default
		var text_scale: int = int(font_override_default * difference)
		
		if text_element is RichTextLabel:
			text_element.add_theme_font_size_override("normal_font_size", text_scale)
			return
		text_element.add_theme_font_size_override("font_size", text_scale)

# Saves font size of the text element in metadata
func save_font_size(text_element: Control, _parent: Node) -> void:
	if (text_element == null): return
	if (text_element.has_meta("fsize") == false):
		var font_override_default: int = 0
		if (text_element is RichTextLabel):
			if (text_element["theme_override_font_sizes/normal_font_size"] != null):
				font_override_default = text_element["theme_override_font_sizes/normal_font_size"]
			else:
				font_override_default = 40
		else:
			if (text_element["theme_override_font_sizes/font_size"] != null):
				font_override_default = text_element["theme_override_font_sizes/font_size"]
			else:
				font_override_default= 40
		
		var parent_current_width: float = text_element.size.x
		
		(text_element).set_meta("fsize", font_override_default)
		(text_element).set_meta("pwidth", parent_current_width)
