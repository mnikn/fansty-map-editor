extends Control

onready var ActionMenu = $CanvasLayer/ActionMenu
onready var PropertyPanel = $CanvasLayer/PropertyPanel
onready var MapNodeContainer = $ScrollContainer/ViewportContainer/MapNodeContainer
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
        get_global_mouse_position().x + $ScrollContainer.scroll_horizontal - node.node_size,
        get_global_mouse_position().y + $ScrollContainer.scroll_vertical - node.node_size
    )
    node.connect("on_selected", self, "_on_node_selected", [node])
    self.MapNodeContainer.add_child(node)
    self.ActionMenu.hide()

func _on_DeleteButton_pressed():
    for node in self.MapNodeContainer.get_children():
        if node.selecting:
            self.MapNodeContainer.remove_child(node)
    self.ActionMenu.hide()

func _on_RegenerateButton_pressed():
    for node in self.MapNodeContainer.get_children():
        if node.selecting:
            node.regenerate()
    self.ActionMenu.hide()


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
