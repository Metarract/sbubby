extends UnitState

class_name MovingState

var bubb_cd = 0.1
var bubble_sfx = preload("res://scenes/bubbles_sfx.tscn")

func _ready():
  print(persistent_state)
  friction_coefficient = 0.99
  pass

func _process(delta):
  # make da bubble sounds :)
  if persistent_state.get_node("sub_body/bubbles").emitting:
    if bubb_cd > 0:
      bubb_cd -= delta
    else:
      var bubbs = bubble_sfx.instance()
      add_child(bubbs)
      bubb_cd = 0.1
    pass

func _physics_process(_delta):
  dv = Vector2.ZERO
  var moving = false
  persistent_state.get_node("sub_body/bubbles").emitting = false
  if Input.is_action_pressed("ui_right"):
    moving = true
    dv.x = speed
    persistent_state.get_node("sub_body/bubbles").emitting = true
  if Input.is_action_pressed("ui_left"):
    moving = true
    dv.x = -speed
    persistent_state.get_node("sub_body/bubbles").emitting = true
  if Input.is_action_pressed("ui_down"):
    moving = true
    dv.y = speed
  if Input.is_action_pressed("ui_up"):
    moving = true
    dv.y = -speed
  # set direction
  if (dv.x < 0):
    persistent_state.get_node("sub_body").scale.x = -1
  elif (dv.x > 0):
    persistent_state.get_node("sub_body").scale.x = 1
  if !moving:
    change_state.call_func("idle")

func _on_air_entered(area: Area2D):
  if (area.collision_layer == 128):
    change_state.call_func("airborne")
