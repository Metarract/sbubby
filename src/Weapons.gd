extends KinematicBody2D
class_name Weapons

var v: Vector2 = Vector2.ZERO
var direction: int = 1
var state: String

func _init():
  state = WeaponState.state

func _ready():
  match state:
    "standard_torpedo":
      $AnimatedSprite.animation = "default"
      v = Vector2(500, 0)
      continue
    "homing_torpedo":
      #TODO -> change how homing is processed
      v = Vector2(100, 0)
      continue
    _:
      $AnimatedSprite.animation = WeaponState.state
      $AnimatedSprite.playing = true
      $AnimatedSprite.rotation = atan2(0, direction)
      v *= direction
  

func _physics_process(delta):
  if GameState.state == "main":
    match WeaponState.state:
      "standard_torpedo":
        pass
      "homing_torpedo":
        pass
      _:
        WeaponState.state = "standard_torpedo"
    var collision = move_and_collide(v * delta)
    if collision:
      handle_collision(collision)
  pass

func kill_projectile():
  queue_free()


func handle_collision(collision: KinematicCollision2D):
  if (collision.collider.collision_layer & 4):
    collision.collider.call("_tick_damage", 20)
  kill_projectile()
  pass
