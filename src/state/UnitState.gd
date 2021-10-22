extends Node2D

class_name UnitState

var change_state
var persistent_state: KinematicBody2D
#
var dv = Vector2.ZERO
var maxspeed: int = 300
var speed_mod: float = 1
var friction_coefficient: float = 1
var friction: float = 0.99
var missile_side = 1
var speed = 10
#
var areaCollider: Area2D
var missile = preload("res://scenes/Weapons.tscn")

func _ready():
  randomize()
  persistent_state.get_node("sub_body/bubbles").emitting = false
  # instance area2d
  areaCollider = AirCollider.getAirCollider(persistent_state.get_node("body_collider"))
  var exitCode
  exitCode = areaCollider.connect("area_entered", self, "_on_air_entered")
  if (exitCode != 0): print("signal didn't connect! " + exitCode)
  exitCode = areaCollider.connect("area_exited", self, "_on_air_exited")
  if (exitCode != 0): print("signal didn't connect! " + exitCode)
  add_child(areaCollider)

func _input(event):
  if event.is_action_pressed("player_fire"):
    fire_weapons()

func _physics_process(delta):
  persistent_state.velocity += dv
  persistent_state.velocity *= friction * friction_coefficient
  persistent_state.velocity = persistent_state.velocity.clamped(maxspeed*speed_mod)
  var collision = persistent_state.move_and_collide(persistent_state.velocity * delta)
  if (collision):
    persistent_state.velocity = persistent_state.velocity.bounce(collision.normal)

func setup(
    new_change_state,
    new_persistent_state):
  self.change_state = new_change_state
  self.persistent_state = new_persistent_state
  pass

func fire_weapons():
  var new_missile = missile.instance()
  new_missile.v.x = persistent_state.velocity.x
  var sub_body = persistent_state.get_node("sub_body")
  new_missile.position = to_global(sub_body.get_node("weapon_pos").position)
  new_missile.direction = sub_body.scale.x
  new_missile.z_index = missile_side
  missile_side *= -1
  var root = get_tree().get_root()
  root.add_child(new_missile)
  (get_tree()).set_input_as_handled()

func _on_air_entered(_area: Area2D):
  pass

func _on_air_exited(_area: Area2D):
  pass
