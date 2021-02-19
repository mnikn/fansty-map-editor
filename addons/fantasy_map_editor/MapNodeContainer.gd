extends Control

signal on_mouse_event(event)
signal on_gui_input(event)

func _input(event):
	if event is InputEventMouseButton:
		self.emit_signal("on_mouse_event", event)

func _on_NodeContainer_gui_input(event):
	self.emit_signal("on_gui_input", event)
