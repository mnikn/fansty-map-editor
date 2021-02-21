extends Control

var EditorNodeScene = preload("./EditorNode.tscn")
onready var NodeContainer = $NodeContainer
onready var ActionMenu = $CanvasLayer/ActionMenu
var config_line_color = Color("#000")
var config_line_width = 1
var config_points = 20
var config_size = 50
var config_random_size = 10
var config_map_size = Vector2(2048, 1200)
var config_solid = true
var config_solid_color = Color("#fff")

var selecting_node = null

func _ready():
    pass

func _on_AddButton_pressed():
    var node = EditorNodeScene.instance()
    var pos = self.NodeContainer.get_viewport().get_mouse_position()
    node.origin = Vector2(
        (pos.x + self.NodeContainer.scroll_offset.x / self.NodeContainer.zoom) - node.node_size,
        (pos.y + self.NodeContainer.scroll_offset.y / self.NodeContainer.zoom) - node.node_size
    )
    node.random_size = self.config_random_size
    node.points = self.config_points
    node.node_size = self.config_size
    node.line_color = self.config_line_color
    node.line_width = self.config_line_width
    node.solid = self.config_solid
    node.solid_color = self.config_solid_color
    node.connect("dragged", self, "_on_node_dragged", [node])
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

func _process(delta):
    var selected_node = null
    for child in self.NodeContainer.get_children():
        if child is GraphNode and child.selected:
            selected_node = child
    self.selecting_node = selected_node

func _on_node_dragged(from, to, node):
    pass
#    node.offset.x = clamp(to.x, -INF, self.config_map_size.x)
#    node.offset.y = clamp(to.y, -INF, self.config_map_size.y)

func _on_NodeContainer_scroll_offset_changed(ofs):
    self.NodeContainer.scroll_offset.x = clamp(ofs.x, 0, self.config_map_size.x - self.NodeContainer.rect_size.x + 30)
    self.NodeContainer.scroll_offset.y = clamp(ofs.y, 0, self.config_map_size.y - self.NodeContainer.rect_size.y + 200)
