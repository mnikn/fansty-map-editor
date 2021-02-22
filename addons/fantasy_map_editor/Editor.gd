extends Control

onready var PropertyPanel = $CanvasLayer/PropertyPanel
onready var MapNodeContainer = $Layout/Layout/MapContainer/ViewportContainer/Viewport/Map/NodeContainer
onready var Map = $Layout/Layout/MapContainer/ViewportContainer/Viewport/Map
var EditorNodeScene = preload("./EditorNode.tscn")

func _ready():
	$Layout/Layout/SettingPanel/MarginContainer/Layout/GeneralSetting/Layout/Layout/MapBgValue.color = self.MapNodeContainer.get("custom_styles/bg").bg_color
	$Layout/Layout/SettingPanel/MarginContainer/Layout/GeneralSetting/Layout/Layout/LineColorValue.color = self.Map.config_line_color
	$Layout/Layout/SettingPanel/MarginContainer/Layout/GeneralSetting/Layout/Layout/LineWidthValue.value = self.Map.config_line_width
	$Layout/Layout/SettingPanel/MarginContainer/Layout/GeneralSetting/Layout/Layout/MapSizeValue/Width.value = self.Map.config_map_size.x
	$Layout/Layout/SettingPanel/MarginContainer/Layout/GeneralSetting/Layout/Layout/MapSizeValue/Height.value = self.Map.config_map_size.y
	$Layout/Layout/SettingPanel/MarginContainer/Layout/GeneralSetting/Layout/Layout/GridSnapValue.pressed =  self.Map.NodeContainer.use_snap
	$Layout/Layout/SettingPanel/MarginContainer/Layout/NodeSetting/Layout/Layout/SoildValue.pressed = self.Map.config_solid
	$Layout/Layout/SettingPanel/MarginContainer/Layout/NodeSetting/Layout/Layout/SoildColorValue.color = self.Map.config_solid_color

func _process(delta):
	if self.Map.selecting_node != null:
		$Layout/Layout/SettingPanel/MarginContainer/Layout/NodeSetting.visible = true
		$Layout/Layout/SettingPanel/MarginContainer/Layout/NodeSetting/Layout/Layout/RandomSizeValue.value = self.Map.selecting_node.random_size
		$Layout/Layout/SettingPanel/MarginContainer/Layout/NodeSetting/Layout/Layout/SizeValue.value = self.Map.selecting_node.node_size
		$Layout/Layout/SettingPanel/MarginContainer/Layout/NodeSetting/Layout/Layout/PointsValue.value = self.Map.selecting_node.points
		$Layout/Layout/SettingPanel/MarginContainer/Layout/NodeSetting/Layout/Layout/SoildValue.pressed = self.Map.selecting_node.solid
		$Layout/Layout/SettingPanel/MarginContainer/Layout/NodeSetting/Layout/Layout/SoildColorValue.color = self.Map.selecting_node.solid_color
	else:
		$Layout/Layout/SettingPanel/MarginContainer/Layout/NodeSetting.visible = false
	
	var format_str = "NodeContainer scroll offset: %sx%s"
	$Layout/DebugPanel/Layout/NodeConatinerInfo.text = format_str % [self.MapNodeContainer.scroll_offset.x, self.MapNodeContainer.scroll_offset.y]

func _on_SizeValue_value_changed(value):
	self.Map.config_size = value
	var node = self.Map.selecting_node
	node.node_size = value

func _on_PointsValue_value_changed(value):
	self.Map.config_points = value
	var node = self.Map.selecting_node
	node.points = value
	
func _on_RandomSizeValue_value_changed(value):
	self.Map.config_random_size = value
	var node = self.Map.selecting_node
	node.random_size = value

func _on_LineWidthValue_value_changed(value):
	self.Map.config_line_width = value
	for node in self.MapNodeContainer.get_children():
		if node.is_in_group("EditorNode"):
			node.line_width = value

func _on_LineColorValue_color_changed(color):
	self.Map.config_line_color = color
	for node in self.MapNodeContainer.get_children():
		if node is GraphNode:
			node.line_color = color
			
func _on_MapBgValue_color_changed(color):
#    self.MapNodeContainer
	var bg = StyleBoxFlat.new()
	bg.bg_color = color
	self.MapNodeContainer.set("custom_styles/bg", bg)


func _on_Width_value_changed(value):
	self.Map.config_map_size.x = value
#    self.MapNodeContainer.rect_min_size.x = value
#    self.MapNodeContainer.rect_size = self.MapNodeContainer.rect_min_size

func _on_Height_value_changed(value):
	self.Map.config_map_size.y = value    
#    self.MapNodeContainer.rect_min_size.y = value
#    self.MapNodeContainer.rect_size = self.MapNodeContainer.rect_min_size

func _on_GridSnapValue_toggled(button_pressed):
	self.Map.NodeContainer.use_snap = button_pressed


func _on_SoildValue_toggled(button_pressed):
	self.Map.config_solid = button_pressed
	var node = self.Map.selecting_node
	if node != null:
		node.solid = button_pressed

func _on_SoildColorValue_color_changed(color):
	self.Map.config_solid_color = color
	var node = self.Map.selecting_node
	if node != null:
		node.solid_color = color
