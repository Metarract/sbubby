extends Node2D

var player: Node2D
var circle_occluder_array = []

func _ready():
  var children = self.get_children()
  for child in children:
    var occluder = LightOccluder2D.new()
    occluder.occluder = OccluderPolygon2D.new()
    if child.get_class() == "CollisionPolygon2D":
      occluder.occluder.polygon = child.polygon
      child.add_child(occluder)

    if child.get_class() == "CollisionShape2D":
      if child.shape.get_class() == "CircleShape2D":
        
        var radius = child.shape.radius
        var polygonVectorPoints: PoolVector2Array = [
          Vector2(radius, -1),
          Vector2(radius, 1),
          Vector2(-radius, 1),
          Vector2(-radius, -1),
        ]
        occluder.occluder.polygon = polygonVectorPoints
        child.add_child(occluder)
        circle_occluder_array.append(occluder)
        
func _process(delta):
  for object in circle_occluder_array:
    object.rotation += delta
    # TODO -> get position of player
    # make local to object
    # rotate object to player position
    pass

