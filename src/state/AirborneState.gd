extends UnitState

class_name AirborneState

func _ready():
  persistent_state.get_node("sub_body/bubbles").emitting = false

func _process(_delta):
  persistent_state.get_node("sub_body/bubbles").emitting = false
  dv.y = 9.8

func _on_air_exited(area: Area2D):
  if (area.collision_layer == 128):
    var rand = ceil(randf()*3)
    var splash = persistent_state.get_node("sub_body/splash/splash" + str(rand))
    splash.play()
    persistent_state.splash_cd = 1
    change_state.call_func("idle")
