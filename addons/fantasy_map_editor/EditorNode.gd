extends GraphNode

signal on_selected()

export var origin = Vector2.ZERO setget set_origin
export var node_size = 50 setget set_node_size
export var line_width = 2 setget set_line_width
export var line_color = Color.black setget set_line_color
export var points = 20 setget set_points
export var random_size = 10 setget set_random_size
export var solid = false setget set_solid
export var solid_color = Color("#fff") setget set_solid_color

const SPACING = 10
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
    self.rect_size = self.rect_min_size

func regenerate():
    self.shape_points = []
    self.update()

func _draw():
    self.draw_node()
    if self.selected:
        self.draw_container()
#	if self.selecting:
#		self.draw_container()

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
    if self.solid:
        draw_colored_polygon(points_arr, self.solid_color)
    draw_polyline(points_arr, self.line_color, self.line_width, true)

func draw_container():
    var size = self.node_size * 2 + SPACING * 2
    draw_rect(Rect2(
        Vector2.ZERO, 
        Vector2(size, size)), 
        Color("#fff"),
        false,
        3,
        false)
    draw_circle(Vector2(self.node_size + SPACING, self.node_size + SPACING), 2, Color.red)

func set_origin(value):
    origin = value
    self.offset = origin
    self.rect_position = origin

func set_node_size(value):
    if node_size != value:
        node_size = value
        self.rect_min_size = Vector2((node_size + SPACING) * 2, (node_size + SPACING) * 2)
        self.rect_size = self.rect_min_size
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
    
func set_line_width(value):
    if line_width != value:
        line_width = value
        self.update()

func set_line_color(value):
    if line_color != value:
        line_color = value
        self.update()        

func set_solid(value):
    if solid != value:
        solid = value;
        self.update()

func set_solid_color(value):
    if solid_color != value:
        solid_color = value;
        self.update()

func get_random_direction():
    return(1 if randf() > 0.5 else -1)

#
#func _on_EditorNode_raise_request():
#    self.selected
