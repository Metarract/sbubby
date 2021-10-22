extends Node2D

class_name UnitState

var change_state
var persistent_state: KinematicBody2D
var animated_sprite: AnimatedSprite
#
var velocity = Vector2.ZERO
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
  velocity = Vector2.ZERO
  $sub_body/face.play("init")
  $sub_body/bubbles.emitting = false
  # instance area2d
  areaCollider = AirCollider.getAirCollider($body_collider)
  var exitCode
  exitCode = areaCollider.connect("area_entered", self, "_on_air_entered")
  if (exitCode != 0): print("signal didn't connect! " + exitCode)
  exitCode = areaCollider.connect("area_exited", self, "_on_air_exited")
  if (exitCode != 0): print("signal didn't connect! " + exitCode)
  add_child(areaCollider)

func _input(event):
  if event.is_action_pressed("player_fire"):
    fire_weapons()

func _process(_delta):
  # calc depth
  var depth = int(floor(position.y/10))
  if (animated_sprite.animation == "idle" && depth >= 50):
    animated_sprite.play("activate_brights")
  if (animated_sprite.animation == "brights_on" && depth <= 30):
    animated_sprite.play("deactivate_brights")

func _physics_process(_delta):
  velocity += dv
  velocity = velocity.clamped(maxspeed*speed_mod)
  velocity *= friction * friction_coefficient
  var collision = persistent_state.move_and_collide(velocity)
  if (collision):
    velocity = velocity.bounce(collision.normal)

func setup(
    new_change_state,
    new_persistent_state,
    new_animated_sprite):
  self.change_state = new_change_state
  self.persistent_state = new_persistent_state
  self.animated_sprite = new_animated_sprite
  pass

func fire_weapons():
  var new_missile = missile.instance()
  new_missile.v.x = velocity.x
  new_missile.position = to_global($sub_body/weapon_pos.position)
  new_missile.direction = $sub_body.scale.x
  new_missile.z_index = missile_side
  missile_side *= -1
  var root = get_tree().get_root()
  root.add_child(new_missile)
  (get_tree()).set_input_as_handled()

func _on_air_entered(_area: Area2D):
  pass

func _on_air_exited(_area: Area2D):
  pass
