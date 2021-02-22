extends Control

var current_node = null

func _physics_process(delta):
	if self.visible:
		self.update()

func _draw():
	var start_pos = Vector2(
		current_node.offset.x + current_node.node_size,
		current_node.offset.y + current_node.node_size
	)
	var end_pos = self.get_global_mouse_position()
	draw_line(start_pos, end_pos, Color("#000"), 2, true)
