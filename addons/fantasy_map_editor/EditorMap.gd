extends Control

var EditorNodeScene = preload("./EditorNode.tscn")
onready var NodeContainer = $NodeContainer
onready var ActionMenu = $CanvasLayer/ActionMenu
var config_line_color = Color("#000")
var config_line_width = 1
var config_points = 20
var config_size = 50
var config_random_size = 10

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
#    node.connect("raise_request", self, "_on_node_pressed", [node])
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
