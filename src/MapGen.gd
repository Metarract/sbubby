enum RoomEntrances {
  "top" = 1,
  "right" = 2,
  "bottom" = 4,
  "left" = 8,
}

# 00000001
# 00000010
# 00000100

# 00000111
# 00000101

# TODO, MAKE NOT DUMB????
const roomArray = [
  {
    roomid: 99,
    entrances: 7
  }
]

let roomFound = false;
let retries = 0;
while (!roomFound) {
  retries++;
  if (retries > 30) {
    # setRoom
    break;
  }
  const room = roomArray[Math.floor(Math.random() * roomArray.length)]
  if (room.entrances & 4) {
    roomFound = true
    break;
  }
}

