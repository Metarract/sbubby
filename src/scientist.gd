extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var v = 0
var speed = 30
onready var orig_pos_x = position.x


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  position.x += speed*delta
  if position.x > orig_pos_x + 100 or position.x < orig_pos_x - 100:
    speed = speed * -1
    v = 0
    self.scale.x = self.scale.x * -1
  pass
