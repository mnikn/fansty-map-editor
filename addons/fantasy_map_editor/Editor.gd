extends Control

onready var ActionMenu = $CanvasLayer/ActionMenu
onready var PropertyPanel = $CanvasLayer/PropertyPanel
var EditorNodeScene = preload("./EditorNode.tscn")

func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_RIGHT and event.pressed:
            var pos = get_global_mouse_position()
            pos.x -= self.ActionMenu.rect_min_size.x / 2
            pos.y -= self.ActionMenu.rect_min_size.y / 2 - 20
            self.ActionMenu.popup(Rect2(pos, self.ActionMenu.rect_min_size))

func _on_AddButton_pressed():
    var node = EditorNodeScene.instance()
    node.origin = Vector2(
        get_global_mouse_position().x - node.node_size,
        get_global_mouse_position().y - node.node_size
    )
    node.connect("on_selected", self, "_on_node_selected", [node])
    $MapNodeContainer.add_child(node)
    self.ActionMenu.hide()

func _on_DeleteButton_pressed():
    for node in $MapNodeContainer.get_children():
        if node.selecting:
            $MapNodeContainer.remove_child(node)
    self.ActionMenu.hide()

func show_property(node):
    self.PropertyPanel.current_node = node
    self.PropertyPanel.popup()

func _process(delta):
    var has_selection = false
    for node in $MapNodeContainer.get_children():
        if node.selecting:
            has_selection = true
    if !has_selection:
        self.PropertyPanel.hide()

func _on_node_selected(node):
#    for child in $MapNodeContainer.get_children():
#        if child != node:
#            child.selecting = false
    self.show_property(node)
