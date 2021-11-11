extends Camera2D
class_name CameraController

var dest: Vector2 = Vector2.ZERO
var follow_transform = Node2D.new()

var last_pos: Vector2 = Vector2.ZERO
var current_pos: Vector2 = Vector2.ZERO

export(float, 0, 1, 0.001) var look_ahead_smoothing

export(float, 0, 1, 0.01) var look_ahead_damping_x
export(float, 0, 1, 0.01) var look_ahead_damping_y

export(float, 0, 1000, 1) var dead_zone_width
export(float, 0, 1000, 1) var dead_zone_height

export(float, 0, 1000, 1) var hard_boundary_width
export(float, 0, 1000, 1) var hard_boundary_height

var dead_zone_box = Line2D.new()
var soft_zone_box = Line2D.new()
var look_ahead_crosshair = Line2D.new()
export(bool) var draw_debug = false
export(float, 0, 20, 0.1) var look_ahead_gizmo_extants

func _ready():
  process_mode = Camera2D.CAMERA2D_PROCESS_PHYSICS
  follow_transform = get_node("../player")
  global_position = to_global(follow_transform.position)
  dest = global_position

func _physics_process(_delta):
  # TODO: switch from this movement interpolation -> getting the actual velocity of the player?
  current_pos = follow_transform.global_position
  var dir_vector = current_pos - last_pos
  dir_vector *= 20 # TODO: multiply vector by lookahead strength
  last_pos = current_pos
  #
  dest = follow_transform.global_position+dir_vector
  var smoothing = look_ahead_smoothing*.2
  var half_x = dead_zone_width/2
  var half_y = dead_zone_height/2
  if dest.x >= position.x-half_x && dest.x <= position.x+half_x && dest.y >= position.y-half_y && dest.y <= position.y+half_y:
    smoothing = 0
  half_x = hard_boundary_width/2
  half_y = hard_boundary_height/2
  if dest.x <= position.x-half_x || dest.x >= position.x+half_x || dest.y <= position.y-half_y || dest.y >= position.y+half_y:
    smoothing = 1
  # TODO: Add bounding box hard outer limits
  # TODO: make transitions from deadZ->normal->boundZ smoother? see cinemachine video for details
  global_position = global_position.linear_interpolate(dest, smoothing)
  
  if (draw_debug):
    draw_debug()

func draw_debug():
  var pos = position
  dead_zone_box.position = pos
  soft_zone_box.position = pos
  
  dead_zone_box.clear_points()
  soft_zone_box.clear_points()
  look_ahead_crosshair.clear_points()
  
  dead_zone_box.points = get_debug_box(dead_zone_width, dead_zone_height)
  soft_zone_box.points = get_debug_box(hard_boundary_width, hard_boundary_height)
  look_ahead_crosshair.points = get_debug_lookahead()
  pass
  
func get_debug_box(_width: float, _height: float):
  var half_x = _width/2
  var half_y = _height/2
  return [
    Vector2(half_x,half_y),
    Vector2(half_x,-half_y),
    Vector2(-half_x,-half_y),
    Vector2(-half_x,half_y),
    Vector2(half_x,half_y),
  ]

func get_debug_lookahead():
  return [
    Vector2(dest.x-look_ahead_gizmo_extants, dest.y),
    Vector2(dest.x+look_ahead_gizmo_extants, dest.y),
    Vector2(dest.x, dest.y),
    Vector2(dest.x, dest.y-look_ahead_gizmo_extants),
    Vector2(dest.x, dest.y+look_ahead_gizmo_extants),
   ]

func _on_parent_ready():
  if (OS.is_debug_build()):
    # init debug draws
    dead_zone_box.default_color = Color(0.2,0.2,1,0.5)
    dead_zone_box.width = 2
    dead_zone_box.antialiased = true
    dead_zone_box.joint_mode = 2
    dead_zone_box.z_index = 100
    #
    soft_zone_box.default_color = Color(1,0,0,0.5)
    soft_zone_box.width = 2
    soft_zone_box.antialiased = true
    soft_zone_box.joint_mode = 2
    soft_zone_box.z_index = 100
    #
    look_ahead_crosshair.default_color = Color(1,1,0,0.8)
    look_ahead_crosshair.width = 1
    look_ahead_crosshair.end_cap_mode = 1
    look_ahead_crosshair.z_index = 100
    
    var parent_node = get_parent()
    parent_node.add_child(dead_zone_box)
    parent_node.add_child(soft_zone_box)
    parent_node.add_child(look_ahead_crosshair)
