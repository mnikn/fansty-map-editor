extends Control

onready var PropertyPanel = $CanvasLayer/PropertyPanel
onready var MapNodeContainer = $Layout/Layout/MapContainer/ViewportContainer/Viewport/Map/NodeContainer
onready var Map = $Layout/Layout/MapContainer/ViewportContainer/Viewport/Map
var EditorNodeScene = preload("./EditorNode.tscn")

func _ready():
    $Layout/Layout/SettingPanel/MarginContainer/Layout/GeneralSetting/Layout/Layout/MapBgValue.color = self.MapNodeContainer.get("custom_styles/bg").bg_color
    $Layout/Layout/SettingPanel/MarginContainer/Layout/GeneralSetting/Layout/Layout/LineColorValue.color = self.Map.config_line_color
    $Layout/Layout/SettingPanel/MarginContainer/Layout/GeneralSetting/Layout/Layout/LineWidthValue.value = self.Map.config_line_width

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

func _process(delta):
    if self.Map.selecting_node != null:
        $Layout/Layout/SettingPanel/MarginContainer/Layout/NodeSetting.visible = true
        $Layout/Layout/SettingPanel/MarginContainer/Layout/NodeSetting/Layout/Layout/RandomSizeValue.value = self.Map.selecting_node.random_size
        $Layout/Layout/SettingPanel/MarginContainer/Layout/NodeSetting/Layout/Layout/SizeValue.value = self.Map.selecting_node.node_size
        $Layout/Layout/SettingPanel/MarginContainer/Layout/NodeSetting/Layout/Layout/PointsValue.value = self.Map.selecting_node.points
    else:
        $Layout/Layout/SettingPanel/MarginContainer/Layout/NodeSetting.visible = false

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
        if node is GraphNode:
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
