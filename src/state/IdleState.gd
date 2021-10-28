extends UnitState

class_name IdleState

func _ready():
  speed = 0
  persistent_state.dv = Vector2.ZERO
  friction_coefficient = 0.95
  self.persistent_state.get_node("sub_body/bubbles").emitting = false

func _process(_delta):
  if Input.is_action_pressed("ui_right") or \
    Input.is_action_pressed("ui_left") or \
    Input.is_action_pressed("ui_up") or \
    Input.is_action_pressed("ui_down"):
    change_state.call_func("moving")

func _on_air_entered(area: Area2D):
  if (area.collision_layer == 128):
    change_state.call_func("airborne")
