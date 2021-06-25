extends Unit

# enum AnglerfishState {
#   Dying,
#   Seeking,
#   Idle,
# }
#TODO write anglerfish ai

var idle_timer: int = 0

func _init():
  state = "idle"

func _process(delta):
  print(idle_timer)
  match state:
    "dying":
      $CollisionPolygon2D.disabled = true
    "idle":
      if idle_timer > 5:
        print('got here')
        $AnimatedSprite.play("idle")
      else:
        idle_timer += delta
    _:
      state = "idle"




func _on_AnimatedSprite_animation_finished():
  if $AnimatedSprite.animation == "idle":
    $AnimatedSprite.playing = false
    idle_timer = 0
  pass # Replace with function body.
