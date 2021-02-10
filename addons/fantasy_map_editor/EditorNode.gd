extends Control

signal on_selected()

export var origin = Vector2.ZERO setget set_origin
export var node_size = 50 setget set_node_size
export var lineWidth = 2
export var lineColor = Color.black
export var pointNum = 12
var selecting = false setget set_selecting

func _input(event):
    if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
        if self.get_global_mouse_position().x >= self.rect_global_position.x and \
            self.get_global_mouse_position().x <= self.rect_global_position.x + self.rect_size.x and \
            self.get_global_mouse_position().y >= self.rect_global_position.y and \
            self.get_global_mouse_position().y <= self.rect_global_position.y + self.rect_size.y:
                self.selecting = true
        else:
            self.selecting = false
#    else:
#        self.selecting = false

func _physics_process(delta):
    if self.selecting and Input.is_mouse_button_pressed(BUTTON_LEFT):
        self.origin = Vector2(
            get_global_mouse_position().x - self.node_size,
            get_global_mouse_position().y - self.node_size
        )

func _ready():
    self.set_origin(origin)
    self.set_node_size(node_size)

func _draw():
    print_debug("draw")
    self.draw_node()
    if self.selecting:
        self.draw_container()

func draw_node():
    var points = PoolVector2Array();
    for i in range(pointNum + 1):
        var degree = i * (360 / pointNum)
#        var x = cos(((PI * 2) / 360) * degree) * radius + origin.x
#        var y = sin(((PI * 2) / 360) * degree) * radius + origin.y
        var x = cos(((PI * 2) / 360) * degree) * node_size + node_size + 10
        var y = sin(((PI * 2) / 360) * degree) * node_size + node_size + 10
        points.append(Vector2(x, y));
    draw_polyline(points, lineColor, lineWidth, true)

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
    self.update()

func set_node_size(value):
    node_size = value
    self.rect_min_size = Vector2((node_size + 10) * 2, (node_size + 10) * 2)
    self.update()

func set_selecting(value):
    if value != selecting:
        self.update()
        if value:
            self.emit_signal("on_selected")
    selecting = value
