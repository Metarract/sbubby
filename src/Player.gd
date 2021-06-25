extends Unit
class_name Player

var prevHealth = health

var crushDepth = 100
var depth: int = 0

signal depth_changed(depth)
signal health_changed(health)
signal crush_depth_changed(crush_depth)

var missile = preload("res://Weapons.tscn")

func _init():
  maxspeed = 300
  friction = 0.99
  speed = 10

func _ready():
  $AnimatedSprite.play("init")
  $AnimatedSprite/Bubbles.emitting = false
  emit_signal("depth_changed", depth)
  emit_signal("health_changed", health)
  emit_signal("crush_depth_changed", crushDepth)

func _input(event):
  if GameState.state == "main":
    if event.is_action_pressed("player_fire"):
      var new_missile = missile.instance()
      new_missile.position = to_global($WeaponInit.position)
      new_missile.direction = $AnimatedSprite.scale.x
      var root = get_tree().get_root()
      root.add_child(new_missile)
      (get_tree()).set_input_as_handled()
      pass

func _physics_process(delta):
  var collision = get_movement(delta)
  if (collision):
    handle_collision(collision)

func _process(_delta):
  # calc depth
  var prevDepth = depth
  depth = int(floor(position.y/10))
  if (prevDepth != depth):
    emit_signal("depth_changed", depth)
  if ($AnimatedSprite.animation == "init" && depth >= 50):
    $AnimatedSprite.play("activate_brights")
  if ($AnimatedSprite.animation == "brights_on" && depth <= 30):
    $AnimatedSprite.play("deactivate_brights")

  # calc health and crush depth
  if (health > 100):
    health = 100
  if (health != prevHealth):
    emit_signal("health_changed", health)
    prevHealth = health
  var prevCrushDepth = crushDepth
  crushDepth = health - fmod(health, 100)
  if (crushDepth != prevCrushDepth):
    emit_signal("crush_depth_changed", crushDepth)
  

func get_movement(delta) -> KinematicCollision2D:
  moving = false
  var collision = _move_and_collide(delta)
  $AnimatedSprite/Bubbles.emitting = false
  if (!airborne):
    if Input.is_action_pressed("ui_right"):
      dv.x += speed
      moving = true
      $AnimatedSprite/Bubbles.emitting = true
    if Input.is_action_pressed("ui_left"):
      dv.x -= speed
      moving = true
      $AnimatedSprite/Bubbles.emitting = true
    if Input.is_action_pressed("ui_down"):
      dv.y += speed
      moving = true
    if Input.is_action_pressed("ui_up"):
      dv.y -= speed
      moving = true
    # decel a bit faster if we've stopped moving
    if (!moving):
      coeff = 0.95
    else:
      coeff = 1
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
  # TODO MOVE THIS TO MAIN FUNC
  return collision

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
