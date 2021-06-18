extends BaseState

func _init():
  states = [
    "main_menu",
    "main",
    "options"
  ]

# TODO, REMOVE ME WHEN WE'RE NOT TESTING GAMEPLAY
func _ready():
  state = "main"
  
# global vars
