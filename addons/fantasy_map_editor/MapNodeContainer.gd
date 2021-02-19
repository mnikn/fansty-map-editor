extends Control

signal show_action_menu(pos)

onready var MapCamera = get_parent().get_node("Camera2D")
var mouse_left_hold_time = 0
var mouse_drag_start_pos = null

func _ready():
	pass
#	self.MapCamera.limit_bottom = self.rect_size.y
#	self.MapCamera.limit_right = self.rect_size.x

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			var pos = get_global_mouse_position()
			
			var ActionMenu = self.get_node("../CanvasLayer/ActionMenu")
			pos.x -= ActionMenu.rect_min_size.x / 2
			pos.y -= ActionMenu.rect_min_size.y / 2 - 20
			ActionMenu.popup(Rect2(pos, ActionMenu.rect_min_size))
#			self.emit_signal("show_action_menu", pos)

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if self.mouse_left_hold_time >= 10 and (self.mouse_drag_start_pos.x != self.get_viewport().get_mouse_position().x || self.mouse_drag_start_pos.y != self.get_viewport().get_mouse_position().y):
			print_debug(self.MapCamera.position.x + self.mouse_drag_start_pos.x - self.get_viewport().get_mouse_position().x)
			self.MapCamera.position = self.get_viewport().get_mouse_position()
		else:
			self.mouse_left_hold_time += 1
			self.mouse_drag_start_pos = self.get_viewport().get_mouse_position()
	else:
		self.mouse_left_hold_time = 0
