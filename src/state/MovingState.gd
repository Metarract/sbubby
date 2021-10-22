extends UnitState

class_name MovingState

var bubb_cd = 0.6
# TODO -> check to see if we can put this on
# persistent state and call it FROM persistent
var bubble_sfx = preload("res://scenes/bubbles_sfx.tscn")

func _ready():
  friction_coefficient = 1
  pass

func _process(delta):
  # make da bubble sounds :)
  if ($sub_body/bubbles.emitting):
    if bubb_cd > 0:
      bubb_cd -= delta
    else:
      var bubbs = bubble_sfx.instance()
      add_child(bubbs)
      bubb_cd = 0
    pass

func _physics_process(_delta):
  $sub_body/bubbles.emitting = false
  if Input.is_action_pressed("ui_right"):
    dv.x = speed
    $sub_body/bubbles.emitting = true
  if Input.is_action_pressed("ui_left"):
    dv.x = -speed
    $sub_body/bubbles.emitting = true
  if Input.is_action_pressed("ui_down"):
    dv.y = speed
  if Input.is_action_pressed("ui_up"):
    dv.y = -speed
  # set direction
  if (dv.x < 0):
    $sub_body.scale.x = -1
  elif (dv.x > 0):
    $sub_body.scale.x = 1
  pass

func _on_air_entered(area: Area2D):
  if (area.collision_layer == 128):
    change_state.call_func("airborne")
