extends Node
class_name MapGen

enum RoomEntrances {
  TOP = 1,
  RIGHT = 2,
  BOTTOM = 4,
  LEFT = 8,
}

var roomArray = [];

export var MAX_MAP_WIDTH = 10
export var MAX_MAP_HEIGHT = 10

func _init():
  randomize()
  print('Initializing Map Nodes')
  initMap()
  print('Done')
  print('Walking Map')
  walkMap()
  print('Done')

func initMap():
  for _x in range(MAX_MAP_WIDTH):
    var tempArray = []
    for _y in range(MAX_MAP_HEIGHT):
      tempArray.push_back({
        "x": _x,
        "y": _y,
        "bits": 0,
        "room_id": 0
      })
      pass
    pass
    roomArray.push_back(tempArray)

func walkMap():
  var initX = floor(randf() * roomArray.size())
  var currentRoom = roomArray[initX][0]
  while currentRoom.y < roomArray[0].size()-1:
    var validRooms = probeNodes(currentRoom)
    randomize()
    var index = floor(randf() * validRooms.size())
    var r = validRooms[index]
    currentRoom = roomArray[r.x][r.y]
    currentRoom.room_id = 1
  for _ry in roomArray.size():
    print("\n")
    for _rx in roomArray.size():
      printraw(roomArray[_rx][_ry].room_id)

func probeNodes(currentRoom) -> Array:
  var validRooms = []
  pushRoomIfValid(validRooms, currentRoom.x-1, currentRoom.y)
  pushRoomIfValid(validRooms, currentRoom.x+1, currentRoom.y)
  pushRoomIfValid(validRooms, currentRoom.x, currentRoom.y+1)
  return validRooms

func pushRoomIfValid(validRooms: Array, x: int, y: int):
  if x < 0 || x > MAX_MAP_WIDTH-1 || y > MAX_MAP_HEIGHT-1:
    return
  if roomArray[x][y].room_id == 0:
    validRooms.push_back(Vector2(x,y))
  pass

