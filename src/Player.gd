extends KinematicBody2D

export var accel = 10
export var friction = 0.99
export var maxspeed = 300
var v:Vector2 = Vector2.ZERO

var armor = 100
var crushDepth = 100
var depth: int = 0

signal depth_changed(depth)
signal armor_changed(armor)
signal crush_depth_changed(crush_depth)

var missile = preload("res://Weapons.tscn")

func _input(event):
  if event.is_action_pressed("player_fire"):
    var new_missile = missile.instance()
    new_missile.position = to_global($WeaponInit.position)
    var root = get_tree().get_root()
    root.add_child(new_missile)
    pass

func _ready():
  print(GameState.state)
  $AnimatedSprite.play("init")
  $AnimatedSprite/Bubbles.emitting = false
  emit_signal("depth_changed", depth)
  emit_signal("armor_changed", armor)
  emit_signal("crush_depth_changed", crushDepth)

func _physics_process(delta):
  var collision = get_movement(delta)
  if (collision):
    handle_collision(collision)

func _process(delta):

  # calc depth
  var prevDepth = depth
  depth = int(floor(position.y/10))
  if (prevDepth != depth):
    emit_signal("depth_changed", depth)
  if ($AnimatedSprite.animation == "init" && depth >= 50):
    $AnimatedSprite.play("activate_brights")
  if ($AnimatedSprite.animation == "brights_on" && depth <= 30):
    $AnimatedSprite.play("deactivate_brights")

  # calc armor and crush depth
  var prevArmor = armor
  if (armor < 100):
    armor = 100
  if (armor != prevArmor):
    emit_signal("armor_changed", armor)
  var prevCrushDepth = crushDepth
  crushDepth = armor - fmod(armor, 100)
  if (crushDepth != prevCrushDepth):
    emit_signal("crush_depth_changed", crushDepth)
  

func get_movement(delta) -> KinematicCollision2D:
  var dv:Vector2 = Vector2.ZERO
  var airborne = false
  var moving = false
  $AnimatedSprite/Bubbles.emitting = false
  var coeff = 1
  
  if (position.y <= -7):
    airborne = true
  if (!airborne):
    if Input.is_action_pressed("ui_right"):
      dv.x += accel
      moving = true
      $AnimatedSprite/Bubbles.emitting = true
    if Input.is_action_pressed("ui_left"):
      dv.x -= accel
      moving = true
      $AnimatedSprite/Bubbles.emitting = true
    if Input.is_action_pressed("ui_down"):
      dv.y += accel
      moving = true
    if Input.is_action_pressed("ui_up"):
      dv.y -= accel
      moving = true
    # decel a bit faster if we've stopped moving
    if (!moving):
      coeff = 0.95
  else:
    dv.y += 9.8
  # fast-track decel if we're close enough
  if abs(dv.x) < 2:
    dv.x = 0
  if abs(dv.y) < 2:
    dv.y = 0
  # set direction, just use flip_h to determine direction to shoot as well
  if (dv.x < 0):
    $AnimatedSprite.scale.x = -1
  elif (dv.x > 0):
    $AnimatedSprite.scale.x = 1
  if v.length() > 0:
    v *= friction * coeff
  v += dv
  v = v.clamped(maxspeed)
  # TODO MOVE THIS TO MAIN FUNC
  return move_and_collide(v * delta)

func handle_collision(collision):
  v = v.bounce(collision.normal)
  v = v.clamped(maxspeed*0.75)

func _on_AnimatedSprite_animation_finished():
  if ($AnimatedSprite.animation == "activate_brights"):
    $AnimatedSprite.play("brights_on")
  if ($AnimatedSprite.animation == "deactivate_brights"):
    $AnimatedSprite.play("init")
    

func _on_AnimatedSprite_frame_changed():
  if ($AnimatedSprite.animation == "activate_brights" && $AnimatedSprite.frame == 11):
    $Light2D.enabled = true
  if ($AnimatedSprite.animation == "deactivate_brights" && $AnimatedSprite.frame == 2):
    $Light2D.enabled = false
