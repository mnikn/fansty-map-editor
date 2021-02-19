extends Control

signal on_selected()

export var origin = Vector2.ZERO setget set_origin
export var node_size = 50 setget set_node_size
export var lineWidth = 2
export var lineColor = Color.black
export var points = 20 setget set_points
export var random_size = 10 setget set_random_size

const SPACING = 10
var selecting = false setget set_selecting
var mouse_hold_time = 0
var noise = OpenSimplexNoise.new()
var shape_points = []

func _ready():
	randomize()
	# Configure
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 8
	noise.persistence = 0.8
	noise.lacunarity = 1.5
	
	self.rect_min_size = Vector2((node_size + SPACING) * 2, (node_size + SPACING) * 2)

	
func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if self.is_in_mouse():
			self.selecting = true
		else:
			if self.get_parent().get_parent() != null:
				self.selecting = false

func _physics_process(delta):
	if self.selecting and Input.is_mouse_button_pressed(BUTTON_LEFT):
		if mouse_hold_time >= 10:
			self.origin = Vector2(
				get_global_mouse_position().x - self.node_size,
				get_global_mouse_position().y - self.node_size
			)
		else:
			mouse_hold_time += 1
	else:
		mouse_hold_time = 0

func regenerate():
	self.shape_points = []
	self.update()

func _draw():
	self.draw_node()
	if self.selecting:
		self.draw_container()

func draw_node():
	var points_arr = self.shape_points
	if len(points_arr) <= 0:
		var curve = Curve2D.new()
		for i in range(self.points + 1):
			var degree = i * (360 / (self.points))
			var x = cos(((PI * 2) / 360) * degree) * node_size + node_size + SPACING
			var y = sin(((PI * 2) / 360) * degree) * node_size + node_size + SPACING 
			
			points_arr.push_back(Vector2(x, y))
			
			var control_point1 = Vector2(randf() * self.random_size * get_random_direction(),randf() * self.random_size * get_random_direction())
			var control_point2 = Vector2(randf() * self.random_size * get_random_direction(),randf() * self.random_size * get_random_direction())
			curve.add_point(points_arr[i], control_point1, control_point2)
		points_arr = curve.get_baked_points()
	self.shape_points = points_arr
	draw_polyline(points_arr, lineColor, lineWidth, true)

func draw_container():
	var size = self.node_size * 2 + SPACING * 2
	draw_rect(Rect2(
		Vector2.ZERO, 
		Vector2(size, size)), 
		Color("2c2c2c"), 
		false)
	draw_circle(Vector2(self.node_size + SPACING, self.node_size + SPACING), 2, Color.red)

func set_origin(value):
	origin = value
	self.rect_position = origin

func set_node_size(value):
	if node_size != value:
		node_size = value
		self.rect_min_size = Vector2((node_size + SPACING) * 2, (node_size + SPACING) * 2)
		self.shape_points = []
		self.update()

func set_points(value):
	if points != value:
		points = value - 1 if int(value) % 2 != 0 else value
		self.shape_points = []
		self.update()

func set_random_size(value):
	if random_size != value:
		random_size = value
		self.shape_points = []
		self.update()

func set_selecting(value):
	if value != selecting:
		self.update()
		self.mouse_hold_time = 0        
		if value:
			self.emit_signal("on_selected")
	selecting = value

func is_in_mouse():
	return self.get_global_mouse_position().x >= self.rect_global_position.x and \
	self.get_global_mouse_position().x <= self.rect_global_position.x + self.rect_size.x and \
	self.get_global_mouse_position().y >= self.rect_global_position.y and \
	self.get_global_mouse_position().y <= self.rect_global_position.y + self.rect_size.y

func get_random_direction():
	return(1 if randf() > 0.5 else -1)
