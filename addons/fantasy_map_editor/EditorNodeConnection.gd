extends GraphNode

export var line_color = Color("#000")
export var line_width = 2

var start_node = null
var end_node = null

func _physics_process(delta):
	if self.start_node != null and self.end_node != null:
		self.update()

func _draw():
	var start_pos = Vector2(
		self.start_node.offset.x + self.start_node.node_size + self.start_node.SPACING,
		self.start_node.offset.y + self.start_node.node_size + self.start_node.SPACING
	)
	var end_pos = Vector2(
		self.end_node.offset.x + self.end_node.node_size + self.end_node.SPACING,
		self.end_node.offset.y + self.end_node.node_size + self.end_node.SPACING
	)
	draw_line(start_pos, end_pos, self.line_color, self.line_width, true)
