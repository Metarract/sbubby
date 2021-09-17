extends Camera2D
class_name CameraController

var dest: Vector2 = Vector2.ZERO
var followTransform: Node2D

var lastPos: Vector2 = Vector2.ZERO
var currentPos: Vector2 = Vector2.ZERO

var lookaheadX: float
var lookaheadY: float

var geoPointsArray: PoolVector2Array = []

export(float, 0, 1, 0.01) var lookAheadSmoothing

export(float, 0, 1, 0.01) var lookAheadXDamping
export(float, 0, 1, 0.01) var lookAheadYDamping

export(float, 0, 1000, 0.1) var deadZoneWidth
export(float, 0, 1000, 0.1) var deadZoneHeight

export(float, 0, 1000, 0.1) var softZoneWidth
export(float, 0, 1000, 0.1) var softZoneHeight

var deadZoneBox = Line2D.new()
var softZoneBox = Line2D.new()
var lookAheadPoint = Line2D.new()
export(float, 0, 20, 0.1) var lookAheadGizmoExtents

func _ready():
  process_mode = Camera2D.CAMERA2D_PROCESS_PHYSICS
  followTransform = $"/root/PlayerNode"
  position = to_global(followTransform.position)
  dest = position
  if (OS.is_debug_build()):
    # init debug draws
    deadZoneBox.default_color = Color(0.2,0.2,1,0.5)
    deadZoneBox.width = 4
    deadZoneBox.antialiased = true
    deadZoneBox.joint_mode = 2
    #
    softZoneBox.default_color = Color(1,0,0,0.5)
    softZoneBox.width = 4
    softZoneBox.antialiased = true
    deadZoneBox.joint_mode = 2
    #
    lookAheadPoint.default_color = Color(1,1,0,0.8)
    lookAheadPoint.width = 1
    lookAheadPoint.end_cap_mode = 1
    
    # add debug draws as children
    var parentNode = get_parent()
    add_child(deadZoneBox)
    add_child(softZoneBox)
    add_child(lookAheadPoint)

func _physics_process(delta):
  # TODO: switch from this movement interpolation -> getting the actual velocity of the player?
  currentPos = followTransform.global_position
  var dirVector = lastPos - currentPos
  lastPos = currentPos
  dirVector *= -25 # TODO: multiply vector by lookahead strength

  dest = dirVector
  global_position = followTransform.global_position.linear_interpolate(followTransform.global_position+dirVector, lookAheadSmoothing)
  
  if (OS.is_debug_build()):
    draw_debug()

func draw_debug():
  deadZoneBox.clear_points()
  softZoneBox.clear_points()
  lookAheadPoint.clear_points()
  
  deadZoneBox.points = getDebugZoneBox(deadZoneWidth, deadZoneHeight)
  softZoneBox.points = getDebugZoneBox(softZoneWidth, softZoneHeight)
#  lookAheadPoint.points = getDebugLookAheadPos()
  pass
  
func getDebugZoneBox(_width: float, _height: float):
  var halfX = _width/2
  var halfY = _height/2
  return [
    Vector2(global_position.x+halfX,global_position.y+halfY),
    Vector2(global_position.x+halfX,global_position.y-halfY),
    Vector2(global_position.x-halfX,global_position.y-halfY),
    Vector2(global_position.x-halfX,global_position.y+halfY),
    Vector2(global_position.x+halfX,global_position.y+halfY),
  ]

func getDebugLookAheadPos():
  return [
    Vector2(dest.x-lookAheadGizmoExtents, dest.y),
    Vector2(dest.x+lookAheadGizmoExtents, dest.y),
    Vector2(dest.x, dest.y),
    Vector2(dest.x, dest.y-lookAheadGizmoExtents),
    Vector2(dest.x, dest.y+lookAheadGizmoExtents),
   ]

var log_counter = 0
func logLess(values):
  log_counter += 1
  if log_counter == 5:
    log_counter = 0
    print('##############')
    for val in values:
      print(val)
