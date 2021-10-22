extends KinematicBody2D

class_name PlayerPersistentState

var states
var state
var engine_cutoff = 8

func _init():
  states = {
    "idle": IdleState,
    "moving": MovingState,
    "airborne": AirborneState,
  }

func _ready():
  change_state("idle")
  pass

func _process(delta):
  if ($sub_body/engine/engine.playing):
    if (engine_cutoff > 0):
      engine_cutoff -= delta
    else:
      $sub_body/engine/engine.volume_db -= delta * 5
    if ($sub_body/engine/engine.volume_db < -80):
      $sub_body/engine/engine.playing = false

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
    self,
    $sub_body/face
  )
  add_child(state)

func _on_AnimatedSprite_animation_finished():
  if ($sub_body/face.animation == "activate_brights"):
    $sub_body/face.play("brights_on")
  if ($sub_body/face.animation == "deactivate_brights"):
    $sub_body/face.play("init")
    

func _on_AnimatedSprite_frame_changed():
  if ($sub_body/face.animation == "activate_brights" && $sub_body/face.frame == 11):
    $headlamp.enabled = true
  if ($sub_body/face.animation == "deactivate_brights" && $sub_body/face.frame == 2):
    $headlamp.enabled = false
