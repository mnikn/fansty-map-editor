extends Container


var EditorNodeScene = preload("./EditorNode.tscn")
onready var NodeContainer = $NodeContainer
onready var ActionMenu = $CanvasLayer/ActionMenu
onready var MapCamera = $Camera2D
var mouse_left_hold_time = 0
var mouse_drag_start_pos = null

var selecting_node = null

func _on_AddButton_pressed():
	var node = EditorNodeScene.instance()
	node.origin = Vector2(
		self.get_viewport().get_mouse_position().x - node.node_size,
		self.get_viewport().get_mouse_position().y - node.node_size
	)
	node.connect("pressed", self, "_on_node_pressed", [node])
	self.NodeContainer.add_child(node)
	self.ActionMenu.hide()
	self.deselect_node()

func _on_DeleteButton_pressed():
	self.NodeContainer.remove_child(self.selecting_node)
	self.ActionMenu.hide()
	self.deselect_node()

func _on_RegenerateButton_pressed():
	if self.selecting_node != null:
		self.selecting_node.regenerate()
	self.ActionMenu.hide()

func _on_NodeContainer_on_mouse_event(event):
	if event.button_index == BUTTON_RIGHT and event.pressed:
		var pos = self.get_viewport().get_mouse_position()
			
		pos.x -= self.ActionMenu.rect_min_size.x / 2
		pos.y -= self.ActionMenu.rect_min_size.y / 2 - 20
		self.ActionMenu.popup(Rect2(pos, self.ActionMenu.rect_min_size))
		
func _on_NodeContainer_on_gui_input(event):
	if event is InputEventMouseButton:
		if self.selecting_node != null:
			self.selecting_node.selecting = false
			self.selecting_node = null

func _physics_process(delta):
	if self.ActionMenu.visible:
		return
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mouse_pos = self.get_viewport().get_mouse_position()
		if self.mouse_left_hold_time >= 10:
			if self.selecting_node != null:
				self.selecting_node.origin = Vector2(
					self.get_local_mouse_position().x - self.selecting_node.node_size,
					self.get_local_mouse_position().y - self.selecting_node.node_size
				)
			elif self.mouse_drag_start_pos.x != mouse_pos.x || self.mouse_drag_start_pos.y != mouse_pos.y:
				self.MapCamera.position = Vector2(
					self.MapCamera.position.x + self.mouse_drag_start_pos.x - mouse_pos.x,
					self.MapCamera.position.y + self.mouse_drag_start_pos.y - mouse_pos.y
				)	
				self.mouse_drag_start_pos = mouse_pos
		else:
			self.mouse_left_hold_time += 1
			self.mouse_drag_start_pos = mouse_pos
	else:
		self.mouse_left_hold_time = 0
		

func _on_node_pressed(node):
	if self.selecting_node != null:
		self.selecting_node.selecting = false
	self.selecting_node = node
	self.selecting_node.selecting = true

func deselect_node():
	if self.selecting_node != null:
		self.selecting_node.selecting = false
	self.selecting_node = null
