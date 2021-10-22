extends KinematicBody2D

class_name PlayerPersistentState

var states
var state

var engine_cutoff = 8
var splash_cd = 20 setget reset_splash_cd
var velocity = Vector2.ZERO

func _init():
  states = {
    "idle": IdleState,
    "moving": MovingState,
    "airborne": AirborneState,
  }

func _ready():
  $sub_body/face.play("idle")
  change_state("airborne")
  pass

func _process(delta):
  var splash = $sub_body/splash
  if (splash_cd > 0):
    splash_cd -= 1
    splash.emitting = true
  else:
    splash.emitting = false
  pass
  # calc depth
  var depth = int(floor(position.y/10))
  var face: AnimatedSprite = $sub_body/face
  if (face.animation == "idle" && depth >= 50):
    face.play("activate_brights")
  if (face.animation == "brights_on" && depth <= 30):
    face.play("deactivate_brights")
  # cutoff engine
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
    self
  )
  add_child(state)

func reset_splash_cd(_val):
  splash_cd = 20

func _on_AnimatedSprite_animation_finished():
  if ($sub_body/face.animation == "activate_brights"):
    $sub_body/face.play("brights_on")
  if ($sub_body/face.animation == "deactivate_brights"):
    $sub_body/face.play("idle")
    

func _on_AnimatedSprite_frame_changed():
  if ($sub_body/face.animation == "activate_brights" && $sub_body/face.frame == 9):
    $headlamp.enabled = true
  if ($sub_body/face.animation == "deactivate_brights" && $sub_body/face.frame == 1):
    $headlamp.enabled = false
