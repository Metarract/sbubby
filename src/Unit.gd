extends KinematicBody2D
class_name Unit

var health: int = 100
var speed: int = 0
var friction: float = 1
var maxspeed: int = 0
var dv: Vector2 = Vector2.ZERO
var v: Vector2 = Vector2.ZERO
var collision: KinematicCollision2D
var moving = false

func _move_and_collide(delta) -> KinematicCollision2D:
  v += dv
  v = v.clamped(maxspeed)
  dv = Vector2.ZERO
  return move_and_collide(v * delta)
