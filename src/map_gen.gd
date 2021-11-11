extends Node
class_name MapGen

const MAP_SIZE = 1184

enum ROOM_ENTRANCES {
  TOP = 1,
  RIGHT = 2,
  BOTTOM = 4,
  LEFT = 8,
}

var room_array = [];

export var MAX_MAP_WIDTH = 10
export var MAX_MAP_HEIGHT = 10

func _init():
  randomize()
  print('Initializing Map Nodes')
  init_map()
  print('Done')
  print('Walking Map')
  walk_map()
  print('Done')
  # for each valid entry
  # check neighbours and set bitmask
  # get list of valid map tiles
  # randomly choose one
  # update 

func init_map():
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
    room_array.push_back(tempArray)

func walk_map():
  var initX = floor(randf() * room_array.size())
  var currentRoom = room_array[initX][0]
  while currentRoom.y < room_array[0].size()-1:
    var valid_rooms = probe_nodes(currentRoom)
    randomize()
    var index = floor(randf() * valid_rooms.size())
    var r = valid_rooms[index]
    currentRoom = room_array[r.x][r.y]
    currentRoom.room_id = 1
  for _ry in room_array.size():
    print("\n")
    for _rx in room_array.size():
      printraw(room_array[_rx][_ry].room_id)

func probe_nodes(currentRoom) -> Array:
  var valid_rooms = []
  push_room_if_valid(valid_rooms, currentRoom.x-1, currentRoom.y)
  push_room_if_valid(valid_rooms, currentRoom.x+1, currentRoom.y)
  push_room_if_valid(valid_rooms, currentRoom.x, currentRoom.y+1)
  return valid_rooms

func push_room_if_valid(valid_rooms: Array, x: int, y: int):
  if x < 0 || x > MAX_MAP_WIDTH-1 || y > MAX_MAP_HEIGHT-1:
    return
  if room_array[x][y].room_id == 0:
    valid_rooms.push_back(Vector2(x,y))
  pass

