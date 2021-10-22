extends UnitState

class_name AirborneState
var splash_cd = 0

func _ready():
  $sub_body/bubbles.emitting = false

func _process(_delta):
  if (splash_cd < 20):
    splash_cd += 1
    $sub_body/splash.emitting = true
  else:
    $sub_body/splash.emitting = false
  pass

func _on_air_exited(area: Area2D):
  if (area.collision_layer == 128):
    var rand = ceil(randf()*3)
    var splash = get_node("sub_body/splash/splash" + str(rand))
    splash.play()
    splash_cd = 0
    change_state.call_func("idle")
