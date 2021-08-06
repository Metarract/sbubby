extends Node2D
class_name CameraController

var dest: Vector2 = Vector2.ZERO

export(float, 0, 1, 0.01) var interpolationAmount = 0

func _process(_delta):
  position = position.linear_interpolate(dest, interpolationAmount)
  pass
