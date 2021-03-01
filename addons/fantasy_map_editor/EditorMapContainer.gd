extends Control


onready var Map = $ViewportContainer/Viewport/Map
onready var Preview = $Preview/Viewport/Container
onready var PreviewCamera = $Preview/Viewport/Camera2D

func _process(delta):
	self.Preview.set("custom_styles/panel", self.Map.NodeContainer.get("custom_styles/bg"))
	self.PreviewCamera.zoom.x = self.Map.config_map_size.x / $Preview.rect_size.x
	self.PreviewCamera.zoom.y = self.Map.config_map_size.y / $Preview.rect_size.y
#    self.Preview.rect_min_size = self.Map.config_map_size
#    self.Preview.rect_size = self.Preview.rect_min_size
	for child in self.Preview.get_children():
		self.Preview.remove_child(child)
	for node in self.Map.NodeContainer.get_children():
		if node.is_in_group("EditorNode"):
			var clone_node = node.duplicate()
			clone_node.shape_points = node.shape_points
			clone_node.rect_position = node.rect_position
			clone_node.selected = false
			self.Preview.add_child(clone_node)

func save():
	var screen = self.MapNodeContainer.get_viewport().get_texture().get_data()
	screen.flip_y()
	var buffer = screen.save_png_to_buffer()
	var pic = Image.new()
	pic.load_png_from_buffer(buffer)
	pic.resize(150, 150,Image.INTERPOLATE_NEAREST)
	var texture = ImageTexture.new()
	texture.create_from_image(pic)
	$CanvasLayer/Preview/Pic.texture = texture



