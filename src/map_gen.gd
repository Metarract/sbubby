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

export var max_map_width = 10
export var max_map_height = 10

func _ready():
  self.position = get_parent().get_node("./player").position
  randomize()
  print('Initializing Map Nodes')
  init_map()
  print('Done')
  print('Walking Map')
  walk_map()
  print('Done')
  print('Setting Map Tile Coordinates')
  set_tile_coordinates()
  print('Done')
  print("Placing Map Tiles")
  set_map_tile()
  # get list of valid map tiles
  # randomly choose one
  # update
#  print_map_tiles()


func init_map():
  for _x in range(max_map_width):
    var tempArray = []
    for _y in range(max_map_height):
      tempArray.push_back({
        "x": _x,
        "y": _y,
        "bits": 0,
        "room_id": "0"
      })
      pass
    pass
    room_array.push_back(tempArray)

func walk_map():
  var initX = floor(randf() * room_array.size())
  var current_room = room_array[initX][0]
  self.position.x -= current_room.x * MAP_SIZE
  self.position.y -= current_room.y * MAP_SIZE
  current_room.bits = 1
  current_room.room_id = "1"
  while current_room.y < room_array[0].size()-1:
    var valid_rooms = probe_nodes(current_room)
    randomize()
    var index = floor(randf() * valid_rooms.size())
    var r = valid_rooms[index]
    # bitshift the old and the new room based on the differences between the current x/y and the new x/y
    var move_diff = Vector2(r.x-current_room.x,r.y-current_room.y)
    var new_room_bits = 0
    match move_diff:
      Vector2(1,0): # moving right
        current_room.bits += 2
        new_room_bits += 8
      Vector2(-1,0): # moving left
        current_room.bits += 8
        new_room_bits += 2
      Vector2(0,1): # moving down
        current_room.bits += 4
        new_room_bits += 1
      _:
        printerr("what the fuck kinda room did you enter buddy")
        #
    current_room = room_array[r.x][r.y]
    current_room.bits += new_room_bits
    current_room.room_id = "1"
    if current_room.y == room_array[0].size()-1:
      current_room.bits += 4

func probe_nodes(current_room) -> Array:
  var valid_rooms = []
  push_room_if_valid(valid_rooms, current_room.x-1, current_room.y)
  push_room_if_valid(valid_rooms, current_room.x+1, current_room.y)
  push_room_if_valid(valid_rooms, current_room.x, current_room.y+1)
  return valid_rooms

func push_room_if_valid(valid_rooms: Array, x: int, y: int):
  if x < 0 || x > max_map_width-1 || y > max_map_height-1:
    return
  if room_array[x][y].room_id == "0":
    valid_rooms.push_back(Vector2(x,y))
  pass

func set_tile_coordinates():
  for _x in range(max_map_width):
    for _y in range(max_map_height):
      var current_room = room_array[_x][_y]
      if current_room.room_id == "1":
        current_room.x *= MAP_SIZE
        current_room.y *= MAP_SIZE

func set_map_tile():
  for _x in range(max_map_width):
    for _y in range(max_map_height):
      var current_room = room_array[_x][_y]
      if current_room.room_id == "1":
        current_room.room_id = String(current_room.bits) + "-0"
        # TODO this is definitely loading thigns too many times
        var map_tile = load("res://scenes/map/" + current_room.room_id + ".tscn")
        var map_tile_instance = map_tile.instance()
        print(map_tile_instance)
        add_child(map_tile_instance)
        map_tile_instance.position = Vector2(current_room.x,current_room.y)
        
func print_map_tiles():
  for _ry in room_array.size():
    print("\n")
    for _rx in room_array.size():
      var current_room = room_array[_rx][_ry]
      printraw(current_room.room_id)
      var entry_diff = 5 - current_room.room_id.length()
      for i in entry_diff:
        printraw(" ")
