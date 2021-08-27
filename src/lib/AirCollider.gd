extends Reference
class_name AirCollider

static func getAirCollider(collisionShape=null,shape=null):
  assert(collisionShape != null || shape != null)
  var areaCollider = Area2D.new()
  var collisionShape2d = CollisionShape2D.new()
  if collisionShape != null:
    collisionShape2d.shape = collisionShape.shape
  elif shape != null:
    collisionShape2d.shape = shape
  areaCollider.add_child(collisionShape2d)
  areaCollider.set_collision_mask_bit(7, 128)
  areaCollider.set_collision_layer_bit(0, 1)
  return areaCollider
