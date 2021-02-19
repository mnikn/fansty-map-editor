extends Control

var EditorNodeScene = preload("./EditorNode.tscn")
onready var MapNodeContainer = $ViewportContainer/Viewport/MapNodeContainer 
onready var ActionMenu = $ViewportContainer/Viewport/CanvasLayer/ActionMenu

func _on_AddButton_pressed():
	var node = EditorNodeScene.instance()
	node.origin = Vector2(
		get_global_mouse_position().x - node.node_size,
		get_global_mouse_position().y - node.node_size
	)
	node.connect("on_selected", self, "_on_node_selected", [node])
	self.MapNodeContainer.add_child(node)
	self.ActionMenu.hide()
