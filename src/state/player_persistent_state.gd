extends KinematicBody2D

class_name PlayerPersistentState

export(int) var follow_length = 10

var states
var state

var engine_cutoff = 8
var splash_cutoff = 200
var splash_timer = 0
var velocity = Vector2.ZERO
var dv = Vector2.ZERO

var area_collider: Area2D

var currentPos = Vector2.ZERO
var lastPos = Vector2.ZERO

onready var follow_curve = get_parent().get_node("FollowCurve")

func _init():
  states = {
    "idle": IdleState,
    "moving": MovingState,
    "airborne": AirborneState,
  }

func _ready():
  $sub_body/face.play("idle")
  $sub_body/bubbles.emitting = false
  # instance area2d
  area_collider = AirCollider.get_air_collider($body_collider)
  area_collider.rotation = $body_collider.rotation
  add_child(area_collider)
  change_state("airborne")
  pass

func _process(delta):
  follow_curve.get_node("PathFollow2D").offset = 0
  # make splash bubs for X frames
  var splash = $sub_body/splash
  if (OS.get_ticks_msec() < splash_timer):
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
  call_deferred("add_child", state)

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
