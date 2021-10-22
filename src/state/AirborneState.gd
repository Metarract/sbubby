extends UnitState

class_name AirborneState
var splash_cd = 0

func _ready():
  persistent_state.get_node("sub_body/bubbles").emitting = false

func _process(_delta):
  dv.y = 9.8
  # hey this unloads immediately ya idjit
  var splash = persistent_state.get_node("sub_body/splash")
  if (splash_cd < 20):
    splash_cd += 1
    splash.emitting = true
  else:
    splash.emitting = false
  pass

func _on_air_exited(area: Area2D):
  if (area.collision_layer == 128):
    var rand = ceil(randf()*3)
    var splash = persistent_state.get_node("sub_body/splash/splash" + str(rand))
    splash.play()
    splash_cd = 0
    change_state.call_func("idle")
