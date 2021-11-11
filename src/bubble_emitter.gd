extends "emitter.gd"
class_name BubbleEmitter

func _process(delta):
  process_bubbles(delta);

func process_bubbles(_delta):
  for particle in particle_array:
    var airborne = false
    if !particle.collider:
      var circle_collider = CircleShape2D.new()
      circle_collider.radius = 3
      var area_collider = AirCollider.get_air_collider(null, circle_collider)
      particle.sprite.add_child(area_collider)
      particle.collider = area_collider
    var area_collisions = particle.collider.get_overlapping_areas()
    for collision in area_collisions:
      if collision.collision_layer == 128:
        airborne = true
    if (airborne):
      particle.dy = 0
      if (randi() % 10 > 7):
        kill_particle(particle)
    # TODO have bubbles twitch(?) at the surface
    # kill vertical, killish horizontal, random horizontal movement
