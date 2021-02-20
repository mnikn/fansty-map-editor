extends Control

onready var PropertyPanel = $CanvasLayer/PropertyPanel
onready var MapNodeContainer = $Layout/Layout/MapContainer/ViewportContainer/Viewport/Map/NodeContainer
var EditorNodeScene = preload("./EditorNode.tscn")

func show_property(node):
	self.PropertyPanel.current_node = node
	self.PropertyPanel.popup()

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

