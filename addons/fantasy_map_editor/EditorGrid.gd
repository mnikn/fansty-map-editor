extends Control

export var cell_size = 32

func _draw():
	var rows = floor(self.rect_size.x / cell_size)
	var cols = floor(self.rect_size.y / cell_size)
	var rects = PoolVector2Array([])
	for row in range(rows + 1):
		for col in range(cols + 1):
			var pos = Vector2(row * cell_size, col * cell_size)
			self.draw_rect(
				Rect2(pos, Vector2(cell_size, cell_size)),
				Color(0,0,0,0.2),
				false,
				1,
				true
			)
		
			
