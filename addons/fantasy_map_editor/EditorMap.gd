extends Control


var EditorNodeScene = preload("./EditorNode.tscn")
onready var NodeContainer = $NodeContainer
onready var ActionMenu = $CanvasLayer/ActionMenu
#onready var MapCamera = get_parent().get_node("Camera2D")
var mouse_left_hold_time = 0
var mouse_drag_start_pos = null

var selecting_node = null

func _ready():
	pass

func _on_AddButton_pressed():
	var node = EditorNodeScene.instance()
	var pos = self.NodeContainer.get_viewport().get_mouse_position()
	node.origin = Vector2(
		pos.x + self.NodeContainer.scroll_offset.x - node.node_size,
		pos.y + self.NodeContainer.scroll_offset.y - node.node_size
	)
	node.connect("pressed", self, "_on_node_pressed", [node])
	self.NodeContainer.add_child(node)
	self.ActionMenu.hide()

func _on_DeleteButton_pressed():
	self.NodeContainer.remove_child(self.selecting_node)
	self.ActionMenu.hide()

func _on_RegenerateButton_pressed():
	if self.selecting_node != null:
		self.selecting_node.regenerate()
	self.ActionMenu.hide()

func _on_NodeContainer_popup_request(position):
	position.x -= self.ActionMenu.rect_min_size.x / 2
	position.y -= self.ActionMenu.rect_min_size.y / 2 - 20
	self.ActionMenu.popup(Rect2(position, self.ActionMenu.rect_min_size))
