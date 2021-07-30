extends KinematicBody2D
class_name Weapons

var v: Vector2 = Vector2.ZERO
var dv: Vector2 = Vector2.ZERO
var direction: int = 1
var maxspeed: int = 1
var state: String
var airborne = false

func _init():
  state = WeaponState.state

func _ready():
  match state:
    "standard_torpedo":
      $AnimatedSprite.animation = "default"
      maxspeed = 500
      continue
    "homing_torpedo":
      maxspeed = 100
      #TODO -> change how homing is processed
      continue
    _:
      $AnimatedSprite.animation = state
      $AnimatedSprite.playing = true
      rotation = atan2(0, direction)


func _process(_delta):
  var angle = atan2(v.y,v.x)
  rotation = angle
  pass

func _physics_process(delta):
  if GameState.state == "main":
    if position.y < -7:
      airborne = true
    else:
      airborne = false
    if airborne:
      $AnimatedSprite/Bubbles.emitting = false
      dv.y += 9.8
    else:
      $AnimatedSprite/Bubbles.emitting = true
      match state:
        "standard_torpedo":
          dv.x += 15
          pass
        "homing_torpedo":
          pass
        "dead":
          $AnimatedSprite.frames = null
          $AnimatedSprite/Bubbles.emitting = false
          v = Vector2.ZERO
          dv = Vector2.ZERO
          if $AnimatedSprite/Bubbles.particle_array.size() == 0:
            kill_projectile()
            pass
        _:
          WeaponState.state = "standard_torpedo"
    dv.x *= direction
    v += dv
    v = v.clamped(maxspeed)
    dv = Vector2.ZERO
    var collision = move_and_collide(v * delta)
    if collision:
      handle_collision(collision)
  pass

func kill_projectile():
  queue_free()

func handle_collision(collision: KinematicCollision2D):
  state = "dead"
  if (collision.collider.collision_layer & 4):
    collision.collider.call("_tick_damage", 20)
