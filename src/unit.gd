extends KinematicBody2D
class_name Unit

var health: int = 100
var speed: int = 10
var friction: float = 0.9
var coeff: float = 1
var maxspeed: int = 100
var dv: Vector2 = Vector2.ZERO
var v: Vector2 = Vector2.ZERO
var collision: KinematicCollision2D

var moving = false
var state: String = "default"
var airborne

var count: int = 0

func _move_and_collide(delta) -> KinematicCollision2D:
  if self.airborne:
    dv.y += 9.8
  v += dv
  if !self.airborne:
    v = v.clamped(maxspeed)
  dv = Vector2.ZERO
  if v.length() > 0:
    v *= friction * coeff
  return move_and_collide(v * delta)
