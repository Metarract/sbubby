extends Reference
class_name AirCollider

static func get_air_collider(collision_shape=null,shape=null):
  assert(collision_shape != null || shape != null)
  var area_collider = Area2D.new()
  var collider_shape_2d = CollisionShape2D.new()
  if collision_shape != null:
    collider_shape_2d.shape = collision_shape.shape
  elif shape != null:
    collider_shape_2d.shape = shape
  area_collider.add_child(collider_shape_2d)
  area_collider.set_collision_mask_bit(7, 128)
  area_collider.set_collision_layer_bit(0, 1)
  return area_collider
