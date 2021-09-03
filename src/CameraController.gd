extends Node2D
class_name CameraController

var dest: Vector2 = Vector2.ZERO
var followTransform: Node2D

var lastPos: Vector2
var currentPos: Vector2

var lookaheadX: float
var lookaheadY: float

var geoPointsArray: PoolVector2Array = []

export(float, 0, 10, 0.01) var lookAheadSmoothing

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
  followTransform = $"/root/PlayerNode"
  position = followTransform.position
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
    add_child(deadZoneBox)
    add_child(softZoneBox)
    add_child(lookAheadPoint)

func _process(delta):
  # TODO: why the fuck does the dest jitter back and forth?
  # are we manipulating our vectors incorrectly?
  currentPos = followTransform.position
  # get vector out of lastPos -> currentPos
  # negate vector to get direction
  var dirVector = currentPos - lastPos
  # multiply vector by lookahead strength
  dirVector *= 25
  dest = currentPos + dirVector
  position = position.linear_interpolate(to_local(dest), lookAheadSmoothing*delta)
  lastPos = currentPos
  if (OS.is_debug_build()):
    update()

func _draw():
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
    Vector2(position.x+halfX,position.y+halfY),
    Vector2(position.x+halfX,position.y-halfY),
    Vector2(position.x-halfX,position.y-halfY),
    Vector2(position.x-halfX,position.y+halfY),
    Vector2(position.x+halfX,position.y+halfY),
  ]

func getDebugLookAheadPos():
  return [
    Vector2(dest.x-lookAheadGizmoExtents, dest.y),
    Vector2(dest.x+lookAheadGizmoExtents, dest.y),
    Vector2(dest.x, dest.y),
    Vector2(dest.x, dest.y-lookAheadGizmoExtents),
    Vector2(dest.x, dest.y+lookAheadGizmoExtents),
   ]
