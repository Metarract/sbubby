extends Camera2D
class_name CameraController

var dest: Vector2 = Vector2.ZERO
var followTransform = Node2D.new()

var lastPos: Vector2 = Vector2.ZERO
var currentPos: Vector2 = Vector2.ZERO

var lookaheadX: float
var lookaheadY: float

var geoPointsArray: PoolVector2Array = []

export(float, 0, 1, 0.001) var lookAheadSmoothing

export(float, 0, 1, 0.01) var lookAheadXDamping
export(float, 0, 1, 0.01) var lookAheadYDamping

export(float, 0, 1000, 0.1) var deadZoneWidth
export(float, 0, 1000, 0.1) var deadZoneHeight

export(float, 0, 1000, 0.1) var softZoneWidth
export(float, 0, 1000, 0.1) var softZoneHeight

var deadZoneBox = Line2D.new()
var softZoneBox = Line2D.new()
var lookAheadPoint = Line2D.new()
export(bool) var drawDebugBoxes = false
export(float, 0, 20, 0.1) var lookAheadGizmoExtents

func _ready():
  process_mode = Camera2D.CAMERA2D_PROCESS_PHYSICS
  followTransform = get_node("../player")
  global_position = to_global(followTransform.position)
  dest = global_position

func _physics_process(delta):
  # TODO: switch from this movement interpolation -> getting the actual velocity of the player?
  currentPos = followTransform.global_position
  var dirVector = lastPos - currentPos
  lastPos = currentPos
  dirVector *= -20 # TODO: multiply vector by lookahead strength
  #
  dest = followTransform.global_position+dirVector
  var smoothing = lookAheadSmoothing*.2
  var halfX = deadZoneWidth/2
  var halfY = deadZoneHeight/2
  if dest.x >= position.x-halfX && dest.x <= position.x+halfX && dest.y >= position.y-halfY && dest.y <= position.y+halfY:
    smoothing = 0
  # TODO: Add bounding box hard outer limits
  # TODO: make transitions from deadZ->normal->boundZ smoother? see cinemachine video for details
  global_position = global_position.linear_interpolate(dest, smoothing)
  
  if (drawDebugBoxes):
    draw_debug()

func draw_debug():
  var pos = position
  deadZoneBox.position = pos
  softZoneBox.position = pos
  lookAheadPoint.position = pos
  
  deadZoneBox.clear_points()
  softZoneBox.clear_points()
  lookAheadPoint.clear_points()
  
  deadZoneBox.points = getDebugZoneBox(deadZoneWidth, deadZoneHeight)
  softZoneBox.points = getDebugZoneBox(softZoneWidth, softZoneHeight)
  lookAheadPoint.points = getDebugLookAheadPos()
  pass
  
func getDebugZoneBox(_width: float, _height: float):
  var halfX = _width/2
  var halfY = _height/2
  return [
    Vector2(halfX,halfY),
    Vector2(halfX,-halfY),
    Vector2(-halfX,-halfY),
    Vector2(-halfX,halfY),
    Vector2(halfX,halfY),
  ]

func getDebugLookAheadPos():
  var pos = dest
  return [
    Vector2(pos.x-lookAheadGizmoExtents, pos.y),
    Vector2(pos.x+lookAheadGizmoExtents, pos.y),
    Vector2(pos.x, pos.y),
    Vector2(pos.x, pos.y-lookAheadGizmoExtents),
    Vector2(pos.x, pos.y+lookAheadGizmoExtents),
   ]

func _on_parent_ready():
  if (OS.is_debug_build()):
    # init debug draws
    deadZoneBox.default_color = Color(0.2,0.2,1,0.5)
    deadZoneBox.width = 2
    deadZoneBox.antialiased = true
    deadZoneBox.joint_mode = 2
    deadZoneBox.z_index = 100
    #
    softZoneBox.default_color = Color(1,0,0,0.5)
    softZoneBox.width = 2
    softZoneBox.antialiased = true
    softZoneBox.joint_mode = 2
    softZoneBox.z_index = 100
    #
    lookAheadPoint.default_color = Color(1,1,0,0.8)
    lookAheadPoint.width = 1
    lookAheadPoint.end_cap_mode = 1
    lookAheadPoint.z_index = 100
    
    var parentNode = get_parent()
    parentNode.add_child(deadZoneBox)
    parentNode.add_child(softZoneBox)
    parentNode.add_child(lookAheadPoint)
