extends Light2D

func _process(delta):
  position.x = get_parent().get_node("camera").position.x
  pass
