extends Node
class_name BaseState

# the first state should always be the default state
var states = ["default"]

var state: String = "default" setget set_state, get_state

func _ready():
  state = states[0]

func set_state(new_state):
  if new_state in states:
    state = new_state
  else:
    print("you're an idiot")
    state = states[0]
  
func get_state():
  return state
