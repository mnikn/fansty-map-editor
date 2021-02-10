extends Control

signal on_selected()

export var origin = Vector2.ZERO setget set_origin
export var node_size = 50 setget set_node_size
export var lineWidth = 2
export var lineColor = Color.black
export var points = 12 setget set_points

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
    
func _input(event):
    if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
        if self.is_in_mouse():
            self.selecting = true
        else:
            if self.get_parent().get_parent() != null:
                var panel = self.get_parent().get_parent().PropertyPanel
                if self.get_global_mouse_position().x >= panel.rect_global_position.x and \
                    self.get_global_mouse_position().x <= panel.rect_global_position.x + panel.rect_size.x and \
                    self.get_global_mouse_position().y >= panel.rect_global_position.y and \
                    self.get_global_mouse_position().y <= panel.rect_global_position.y + panel.rect_size.y:
                        return
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

func _draw():
    self.draw_node()
    if self.selecting:
        self.draw_container()

func draw_node():
    var points_arr = self.shape_points
    if len(points_arr) <= 0:
        for i in range(self.points + 1):
            var degree = i * (360 / self.points)
            var x = cos(((PI * 2) / 360) * degree) * node_size + node_size + 10
            var y = sin(((PI * 2) / 360) * degree) * node_size + node_size + 10 
            points_arr.push_back(Vector2(x, y))

        var control_points = []
        for i in range(len(points_arr) - 1):
            var start_point = points_arr[i]
            var end_point = points_arr[i+1]
            var x_diff = ((end_point.x - start_point.x) / 2) + randi() % 10
            var y_diff = ((end_point.y - start_point.y) / 2) + randi() % 10
            var control_point = Vector2(start_point.x + x_diff, start_point.y + y_diff)
            control_points.push_back(control_point)
        for i in range(len(points_arr)*2 - 1):
            if i % 2 != 0:
                points_arr.insert(i, control_points[i/2])
        self.shape_points = points_arr
    draw_polyline(points_arr, lineColor, lineWidth, true)

func get_edge_node(degree):
    var x = cos(((PI * 2) / 360) * degree) * node_size + node_size + 10
    var y = sin(((PI * 2) / 360) * degree) * node_size + node_size + 10
    return Vector2(x, y)

func draw_container():
    var size = self.node_size * 2 + 20
    draw_rect(Rect2(
        Vector2.ZERO, 
        Vector2(size, size)), 
        Color("2c2c2c"), 
        false)
    draw_circle(Vector2(self.node_size + 10, self.node_size + 10), 2, Color.red)

func set_origin(value):
    origin = value
    self.rect_position = origin

func set_node_size(value):
    node_size = value
    self.rect_min_size = Vector2((node_size + 10) * 2, (node_size + 10) * 2)
    self.shape_points = []
    self.update()

func set_points(value):
    if points != value:
        points = value
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
