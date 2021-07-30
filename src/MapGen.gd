extends Node
class_name MapGen

enum RoomEntrances {
  TOP = 1,
  RIGHT = 2,
  BOTTOM = 4,
  LEFT = 8,
}

# TODO, MAKE NOT DUMB????

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
        "room_id": -1
      })
      pass
    pass
    roomArray.push_back(tempArray)

func walkMap():
  # walk along the vector to the next room
  # set room as "occupied"
  # rotate vector, right, left, or none
  # lookahead to see if room is occupied
  # lookahead to see if room is outside bounds
  # if so, reverse and remove option from random vector rotation
  # GOTO rotate vector

  # OR

  # probe all nodes surrounding current node
  # return array of either OCCUPIED or UNOCCUPIED nodes
  # randomly index into array and make new node occupied
  # we should likely only move across and down

  # once we reach final bottom node, push one MORE node into the same vertical array to make boss room
  # final bottom node will always be top down - maybe a rest area? something that denotes the boss is next
  # boss room also always top down
  #
  var initX = floor(randf() * roomArray.size())
  # var direction = 0
  var walk = Vector2(0,1)
  var coords = Vector2(initX,0)
  var currentRoom = roomArray[coords.x][coords.y]
  while coords.y < roomArray[0].size():
    print(Vector2(currentRoom.x,currentRoom.y))
    var validRooms = probeNodes(currentRoom)
    print(validRooms)
    randomize()
    var index = floor(randf() * validRooms.size())
    var r = validRooms[index]
    currentRoom = roomArray[r.x][r.y]
    # currentRoom.room_id = 0
    # var roomValid = false
    # var turnDirections = [-90,0,90]
    # while roomValid == false:
    #   currentRoom = roomArray[coords.x][coords.y]
    #   # randomly choose direction out of directions array
    #   # if invalid splice it out of the array
    #   var dirIndex = floor(randf() * turnDirections.size())
    #   direction = deg2rad(turnDirections[dirIndex])
    #   var tempWalk = walk.rotated(direction)
    #   roomValid = isRoomValid()
    #   if roomValid:
    #     walk = tempWalk
    #     break
    #   else:
    #     turnDirections.remove(dirIndex)
    #     randomize()
    #     pass
    coords.x += walk.x
    coords.y += walk.y

func probeNodes(currentRoom) -> Array:
  var validRooms = []
  pushRoomIfValid(validRooms, currentRoom.x-1, currentRoom.y)
  pushRoomIfValid(validRooms, currentRoom.x+1, currentRoom.y)
  pushRoomIfValid(validRooms, currentRoom.x, currentRoom.y+1)
  return validRooms

func pushRoomIfValid(validRooms: Array, x: int, y: int):
  if x < 0 || x >= MAX_MAP_WIDTH-1 || y >= MAX_MAP_HEIGHT-1:
    return
  if roomArray[x][y].room_id != 0:
    validRooms.push_back(Vector2(x,y))
    pass
  

#var roomFound = false;
#var retries = 0;
#while (!roomFound) {
#  retries++;
#  if (retries > 30) {
#    # setRoom
#    break;
#  }
#  const room = roomArray[Math.floor(Math.random() * roomArray.length)]
#  if (room.entrances & 4) {
#    roomFound = true
#    break;
#  }
#}

