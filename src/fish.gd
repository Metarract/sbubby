extends KinematicBody2D

var flip = false
var last_pos = Vector2.ZERO

var destination = Vector2.ZERO

var school_zone
var school_range = Vector2.ZERO

var wander_cd = 5000
var wander_time = 0
var wander_safely = false

func _init():
  pass
  
func _ready():
  randomize()
  wander_cd = ceil(rand_range(1000,8000))
  school_zone = get_parent().find_node("school_zone")
  var school_shape = school_zone.find_node("CollisionShape2D").shape
  # height and radius are swapped here because our original
  # shape is rotated by 90*
  school_range = Vector2(school_shape.height, school_shape.radius)
  get_safe_destination()
  wander_time = OS.get_ticks_msec() + wander_cd
 
func _physics_process(delta):
  # we need to make sure that if the distance is huge, we're not waiting
  # on our wander cooldown to expire to got towards the zone
  var dest = get_parent().destination
  var dist = position - dest
  if dist.length() > 100:
    get_safe_destination()
  if OS.get_ticks_msec() > wander_time:
    wander_cd = ceil(rand_range(1000,8000))
    wander_time = OS.get_ticks_msec() + wander_cd
    if  wander_safely: 
      get_safe_destination()
      wander_safely = false
    else:
      get_new_random_destination()
  position = position.linear_interpolate(destination, 0.5*delta)
  var vector = position - last_pos
  if (vector.length() > 5*delta):
    $AnimatedSprite.animation = "moving"
    rotation = atan2(vector.y,vector.x)
  else:
    $AnimatedSprite.animation = "idle"
  last_pos = position

func _on_Area2D_area_exited(area):
  if (area == school_zone):
    wander_safely = true

func get_safe_destination():
  var parent = get_parent().destination
  destination = Vector2(
    rand_range(parent.x-school_range.x,parent.x+school_range.x),
    rand_range(parent.y-school_range.y,parent.y+school_range.y)
   )
  pass

func get_new_random_destination():
  destination = Vector2(
    rand_range(position.x-school_range.x*1.5,position.x+school_range.x*1.5),
    rand_range(position.y-school_range.y*1.5,position.y+school_range.y*1.5)
   )
  pass
