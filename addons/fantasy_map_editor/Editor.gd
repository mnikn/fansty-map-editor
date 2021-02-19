extends Control

onready var PropertyPanel = $CanvasLayer/PropertyPanel
onready var MapNodeContainer = $Layout/Layout/MapContainer/ViewportContainer/Viewport/MapNodeContainer
var EditorNodeScene = preload("./EditorNode.tscn")


#func _on_DeleteButton_pressed():
#	for node in self.MapNodeContainer.get_children():
#		if node.selecting:
#			self.MapNodeContainer.remove_child(node)
#	self.ActionMenu.hide()
#
#func _on_RegenerateButton_pressed():
#	for node in self.MapNodeContainer.get_children():
#		if node.selecting:
#			node.regenerate()
#	self.ActionMenu.hide()


func show_property(node):
	self.PropertyPanel.current_node = node
	self.PropertyPanel.popup()

func _process(delta):
	var has_selection = false
	for node in self.MapNodeContainer.get_children():
		if node.selecting:
			has_selection = true
	if !has_selection:
		self.PropertyPanel.hide()

func _on_node_selected(node):
	self.show_property(node)

func update_preivew():
	var screen = self.MapNodeContainer.get_viewport().get_texture().get_data()
	screen.flip_y()
	var buffer = screen.save_png_to_buffer()
	var pic = Image.new()
	pic.load_png_from_buffer(buffer)
	pic.resize(150, 150,Image.INTERPOLATE_NEAREST)
	var texture = ImageTexture.new()
	texture.create_from_image(pic)
	$CanvasLayer/Preview/Pic.texture = texture


func _on_Timer_timeout():
	self.update_preivew()

#
#func _on_MapNodeContainer_show_action_menu(pos):
#	pos.x -= self.ActionMenu.rect_min_size.x / 2
#	pos.y -= self.ActionMenu.rect_min_size.y / 2 - 20
#	self.ActionMenu.popup(Rect2(pos, self.ActionMenu.rect_min_size))
