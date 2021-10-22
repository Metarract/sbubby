extends UnitState

class_name IdleState

func _ready():
  speed = 0
  friction_coefficient = 0.95
  self.persistent_state.get_node("sub_body/bubbles").emitting = false

func _input(event):
  if event.is_action_pressed("ui_right") or \
    event.is_action_pressed("ui_left") or \
    event.is_action_pressed("ui_up") or \
    event.is_action_pressed("ui_down"):
    change_state.call_func("moving")
