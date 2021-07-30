extends "Emitter.gd"
class_name BubbleEmitter

func _process(delta):
  process_bubbles(delta);
  

func process_bubbles(_delta):
  for particle in particle_array:
    if (particle.sprite.position.y <= -7):
      particle.sprite.position.y = -8
      dv *= (1 - damping)
      if (randi() % 10 > 7):
        .kill_particle(particle)
    # TODO have bubbles twitch? at the surface
    # kill vertical, killish horizontal, random horizontal movement
