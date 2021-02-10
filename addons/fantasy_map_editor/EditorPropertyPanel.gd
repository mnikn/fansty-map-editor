extends PopupPanel


var current_node setget set_current_node

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_SizeValue_value_changed(value):
    if current_node:
        current_node.node_size = value


func _on_PointsValue_value_changed(value):
    if current_node:
        current_node.points = value

func set_current_node(value):
    current_node = value
    $MarginContainer/GridContainer/SizeValue.value = current_node.node_size 
    $MarginContainer/GridContainer/PointsValue.value = current_node.points 
