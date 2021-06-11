extends Node
class_name BaseState

var states = ["default"]

var state: String = "default" setget setState, getState

func _ready():
  state = states[0]

func setState(new_state):
  if new_state in states:
    state = new_state
  else:
    print("you're an idiot")
  
func getState():
  return state
