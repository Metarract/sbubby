extends CanvasLayer

func _process(_delta):
  var screen_size = OS.get_screen_size()
  $backdrop.scale = screen_size
  pass
