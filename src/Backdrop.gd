extends CanvasLayer

func _process(_delta):
  var screenSize = OS.get_screen_size()
  $backdrop.scale = screenSize
  pass
