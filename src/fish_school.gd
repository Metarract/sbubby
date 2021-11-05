extends Node2D

# 1. fish stay within school zone
# 2. check move vector for fish school
# 
var destination = Vector2.ZERO
var fish_school = []

var fish = preload("res://scenes/units/fish.tscn")

func _ready():
  randomize()
  var school_size = floor(rand_range(10, 20))
  for i in school_size:
    var new_fish = fish.instance()
    fish_school.append(new_fish)
    add_child(new_fish)
    new_fish.position = Vector2(
      rand_range(-100,100),
      rand_range(-50,50)
     )
    
func _physics_process(delta):
  $school_zone.position = $school_zone.position.linear_interpolate(
    destination,
    0.5*delta
   )
  $keep_away.position = $school_zone.position
