extends Unit
class_name Player
# SBUBBY
var prevHealth = health

var crushDepth = 100
var depth: int = 0
var missile_side = -1

var splash_cd = 0
var bubb_cd = 0
var engine_cutoff = 0

signal depth_changed(depth)
signal health_changed(health)
signal crush_depth_changed(crush_depth)

var missile = preload("res://scenes/weapons.tscn")

var bubble_sfx = preload("res://scenes/bubbles_sfx.tscn")

var areaCollider: Area2D

func _init():
  maxspeed = 300
  friction = 0.99
  speed = 10

func _ready():
  randomize()
  v = Vector2.ZERO
  $sub_body/face.play("init")
  $sub_body/bubbles.emitting = false
  emit_signal("depth_changed", depth)
  emit_signal("health_changed", health)
  emit_signal("crush_depth_changed", crushDepth)
  # instance area2d

  areaCollider = AirCollider.getAirCollider($body_collider)
  var exitCode
  exitCode = areaCollider.connect("area_entered", self, "_on_air_entered")
  if (exitCode != 0): print("signal didn't connect! " + exitCode)
  exitCode = areaCollider.connect("area_exited", self, "_on_air_exited")
  if (exitCode != 0): print("signal didn't connect! " + exitCode)
  add_child(areaCollider)

func _on_air_entered(area: Area2D):
  if (area.collision_layer == 128):
    self.airborne = true

func _on_air_exited(area: Area2D):
  if (area.collision_layer == 128):
    var rand = ceil(randf()*3)
    var splash = get_node("sub_body/splash/splash" + str(rand))
    splash.play()
    splash_cd = 0
    self.airborne = false

func _input(event):
  if GameState.state == "main":
    if event.is_action_pressed("player_fire"):
      var new_missile = missile.instance()
      new_missile.v.x = v.x
      new_missile.position = to_global($sub_body/weapon_pos.position)
      new_missile.direction = $sub_body.scale.x
      new_missile.z_index = missile_side
      missile_side *= -1
      var root = get_tree().get_root()
      root.add_child(new_missile)
      (get_tree()).set_input_as_handled()
      pass

func _physics_process(delta):
  # var areaCollisions = areaCollider.get_overlapping_areas()
  # # get aircollider collisions
  # var airborne = false
  # for areaCollision in areaCollisions:
  #   if areaCollision.collision_layer == 128:
  #     airborne = true
  #   pass
  var collision = get_movement(delta)
  if (collision):
    handle_collision(collision)

func _process(delta):
  # make da bubble sounds :)
  if ($sub_body/bubbles.emitting):
    if bubb_cd < 0.06:
      bubb_cd += delta
    else:
      var bubbs = bubble_sfx.instance()
      add_child(bubbs)
      bubb_cd = 0
    pass
  
  # slowly turn the engine audio off
  if ($sub_body/engine/engine.playing):
    if (engine_cutoff < 8):
      engine_cutoff += delta
    else:
      $sub_body/engine/engine.volume_db -= delta * 5
    if ($sub_body/engine/engine.volume_db < -80):
      $sub_body/engine/engine.playing = false
      
  #emit if we just had a splashdown
  if (splash_cd < 20):
    splash_cd += 1
    $sub_body/splash.emitting = true
  else:
    $sub_body/splash.emitting = false
  # calc depth
  var prevDepth = depth
  depth = int(floor(position.y/10))
  if (prevDepth != depth):
    emit_signal("depth_changed", depth)
  if ($sub_body/face.animation == "init" && depth >= 50):
    $sub_body/face.play("activate_brights")
  if ($sub_body/face.animation == "brights_on" && depth <= 30):
    $sub_body/face.play("deactivate_brights")

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
#  dv.x = 10 # TODO REMOVE ME
  moving = false
  var collision = _move_and_collide(delta)
  $sub_body/bubbles.emitting = false
  if (!self.airborne):
    if Input.is_action_pressed("ui_right"):
      dv.x += speed
      moving = true
      $sub_body/bubbles.emitting = true
    if Input.is_action_pressed("ui_left"):
      dv.x -= speed
      moving = true
      $sub_body/bubbles.emitting = true
    if Input.is_action_pressed("ui_down"):
      dv.y += speed
      moving = true
    if Input.is_action_pressed("ui_up"):
      dv.y -= speed
      moving = true
  else:
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
  # set direction
  if (dv.x < 0):
    $sub_body.scale.x = -1
  elif (dv.x > 0):
    $sub_body.scale.x = 1
  # TODO MOVE THIS TO MAIN FUNC
  return collision

func handle_collision(collision):
  v = v.bounce(collision.normal)
  v = v.clamped(maxspeed*0.75)

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
