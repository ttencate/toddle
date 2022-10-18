extends Node2D

func _ready():
	randomize()

func _unhandled_input(event: InputEvent):
	if OS.is_debug_build():
		if event is InputEventKey:
			match event.scancode:
				KEY_SHIFT:
					Engine.time_scale = 10.0 if event.pressed else 1.0
				KEY_ESCAPE, KEY_Q:
					get_tree().quit()
