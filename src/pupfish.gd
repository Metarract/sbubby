extends KinematicBody2D

var states
var state

func _ready():
  states = {
    "idle": IdleState,
    "moving": MovingState,
    "airborne": AirborneState,
  }


func get_state(state_name):
  if states.has(state_name):
      return states.get(state_name)
  else:
      printerr("No state ", state_name, " in state factory!")


func change_state(new_state):
  if (state != null):
    state.queue_free()
  state = get_state(new_state).new()
  state.setup(
    funcref(self, "change_state"),
    self
  )
  call_deferred("add_child", state)
