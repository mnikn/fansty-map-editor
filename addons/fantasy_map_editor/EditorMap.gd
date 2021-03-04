extends Control

var EditorNodeScene = preload("./EditorNode.tscn")
var EditorNodeConnectionScene = preload("./EditorNodeConnection.tscn")
onready var NodeContainer = $Container/NodeContainer
onready var ActionMenu = $UI/ActionMenu
onready var EditorConnectionPreview = $UI/EditorConnectionPreview
var config_line_color = Color("#000")
var config_line_width = 1
var config_points = 20
var config_size = 50
var config_random_size = 10
var config_map_size = Vector2(2048, 1200) setget set_config_map_size
var config_solid = true
var config_solid_color = Color("#fff")

var selecting_node = null setget set_selecting_node

func _ready():
	self.EditorConnectionPreview.visible = false

func _on_AddButton_pressed():
	var node = EditorNodeScene.instance()
	var pos = self.NodeContainer.get_local_mouse_position()
	node.origin = Vector2(
		pos.x - node.node_size,
		pos.y - node.node_size
	)
	node.random_size = self.config_random_size
	node.points = self.config_points
	node.node_size = self.config_size
	node.line_color = self.config_line_color
	node.line_width = self.config_line_width
	node.solid = self.config_solid
	node.solid_color = self.config_solid_color
#	node.connect("on_selected", self, "_on_node_selected", [node])
	node.connect("gui_input", self, "_on_node_gui_input", [node])
	self.NodeContainer.add_child(node)
	self.ActionMenu.hide()

func _on_DeleteButton_pressed():
	self.NodeContainer.remove_child(self.selecting_node)
	self.ActionMenu.hide()

func _on_RegenerateButton_pressed():
	if self.selecting_node != null:
		self.selecting_node.regenerate()
	self.ActionMenu.hide()

func _on_node_selected(node):
	self.selecting_node = node

func _process(delta):
	$UI/ActionMenu/Layout/DeleteButton.disabled = self.selecting_node == null
	$UI/ActionMenu/Layout/RegenerateButton.disabled = self.selecting_node == null
	$UI/ActionMenu/Layout/ConnectButton.disabled = self.selecting_node == null

func set_config_map_size(value):
	config_map_size = value
	self.NodeContainer.rect_min_size = value
	self.NodeContainer.rect_size = self.NodeContainer.rect_min_size

func _on_ConnectButton_pressed():
	self.EditorConnectionPreview.current_node = self.selecting_node
	self.EditorConnectionPreview.visible = true
	self.ActionMenu.hide()


func _on_NodeContainer_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if self.EditorConnectionPreview.visible:
				if self.selecting_node != self.EditorConnectionPreview.current_node:
					if self.selecting_node != null:
						self.generate_connection(self.EditorConnectionPreview.current_node, self.selecting_node)
					self.EditorConnectionPreview.visible = false
					self.EditorConnectionPreview.current_node = null
			self.selecting_node = null
		elif event.button_index == BUTTON_RIGHT and event.pressed:
			var pos = self.NodeContainer.get_global_mouse_position()
			pos.x -= self.ActionMenu.rect_min_size.x / 2
			pos.y -= self.ActionMenu.rect_min_size.y / 2 - 20
			self.ActionMenu.popup(Rect2(pos, self.ActionMenu.rect_min_size))

func generate_connection(start_node, end_node):
	if start_node in end_node.connections:
		return
	var connection = EditorNodeConnectionScene.instance()
	connection.start_node = start_node
	connection.end_node = end_node
	start_node.connections.push_back(end_node)
	end_node.connections.push_back(start_node)
	self.NodeContainer.add_child(connection)

func set_selecting_node(value):
	if value != null:
		selecting_node = value
		for child in self.NodeContainer.get_children():
			child.selected = false
		if selecting_node != null:
			selecting_node.selected = true
	elif value == null and selecting_node != null:
		selecting_node.selected = false
	selecting_node = value

func _on_node_gui_input(event, node):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			self.selecting_node = node
		elif event.button_index == BUTTON_RIGHT and event.pressed:
			var pos = self.NodeContainer.get_global_mouse_position()
			pos.x -= self.ActionMenu.rect_min_size.x / 2
			pos.y -= self.ActionMenu.rect_min_size.y / 2 - 20
			self.ActionMenu.popup(Rect2(pos, self.ActionMenu.rect_min_size))
