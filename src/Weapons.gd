extends AnimatedSprite
class_name Weapons

func _physics_process(delta):
  print("hi")
  self.position.x += 500*delta
  pass
  #  Input
  # if (Input.is_action_pressed())

func process_missile(missile, delta):
  pass
