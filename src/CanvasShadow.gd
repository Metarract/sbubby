extends CanvasModulate

export(float) var max_depth
export(float) var min_transition_depth

func _on_Player_depth_changed(depth):
  if (depth > max_depth):
    depth = max_depth
  var threshold = (depth - min_transition_depth) / max_depth
  color = Color(0,0,0,threshold)
