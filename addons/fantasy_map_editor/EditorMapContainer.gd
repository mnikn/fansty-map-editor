extends Control


onready var Map = $ViewportContainer/Viewport/Map
onready var Preview = $Preview/Viewport/Container

func _process(delta):
    for child in self.Preview.get_children():
        self.Preview.remove_child(child)
    for node in self.Map.NodeContainer.get_children():
        if node is GraphNode:
            var clone_node = node.duplicate()
            clone_node.shape_points = node.shape_points
            clone_node.rect_position = node.rect_position
            clone_node.selected = false
            self.Preview.add_child(clone_node)
