extends Sprite

# This dictates the size of the viewport used for the "snapshot".
export var source_image_size : Vector2
export var polygon : PoolVector2Array

func _ready():
  var viewport_container = ViewportContainer.new()
  viewport_container.set_size(source_image_size)
  add_child(viewport_container)

  # Additional optimizations can be made on the viewport's properties,
  # depending on the use case.
  var viewport = Viewport.new()
  viewport.set_size(source_image_size)
  viewport_container.add_child(viewport)

  var polygon_2d = Polygon2D.new()
  polygon_2d.set_polygon(polygon)
  viewport.add_child(polygon_2d)

  # Need to yield here when "snapshotting" the first frame of a scene.
  # As described in issue https://github.com/godotengine/godot/issues/19239
  yield(get_tree(), "idle_frame")
  yield(get_tree(), "idle_frame")

  var image = viewport.get_texture().get_data()
  image.flip_y()
  var texture = ImageTexture.new()
  texture.create_from_image(image)
  set_texture(texture)

  # Don't need any of this any longer!
  viewport_container.queue_free()
