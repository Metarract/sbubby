extends Node2D

var player: Node2D
var circle_occluder_array = []

func _ready():
  # TODO: shadows appear strangely on top/edges of terrain, fix??
  player = $"../../../player"
  var children = self.get_children()
  for child in children:
    var occluder = LightOccluder2D.new()
    occluder.z_index = -5
    occluder.light_mask = 4
    occluder.occluder = OccluderPolygon2D.new()
    if child.get_class() == "CollisionPolygon2D":
      occluder.occluder.polygon = child.polygon
      child.add_child(occluder)

    if child.get_class() == "CollisionShape2D":
      if child.shape.get_class() == "CircleShape2D":
        var radius = child.shape.radius
        var polygon_vector_points: PoolVector2Array = [
          Vector2(radius, -1),
          Vector2(radius, 1),
          Vector2(-radius, 1),
          Vector2(-radius, -1),
        ]
        occluder.occluder.polygon = polygon_vector_points
        child.add_child(occluder)
        circle_occluder_array.append(occluder)
      if child.shape.get_class() == "RectangleShape2D":
        var xy = child.shape.extents
        var polygon_vector_points: PoolVector2Array = [
          Vector2(xy.x, xy.y),
          Vector2(xy.x, -xy.y),
          Vector2(-xy.x, -xy.y),
          Vector2(-xy.x, xy.y),
        ]
        occluder.occluder.polygon = polygon_vector_points
        child.add_child(occluder)
        pass
        
func _process(_delta):
  for object in circle_occluder_array:
    var occluder_pos = object.global_position
    var playerPos = player.global_position
    var dx = occluder_pos.x - playerPos.x
    var dy = occluder_pos.y - playerPos.y
    object.rotation = atan2(dy, dx) + rad2deg(90)


