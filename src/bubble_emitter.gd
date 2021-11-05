extends "emitter.gd"
class_name BubbleEmitter

func _process(delta):
  process_bubbles(delta);

func process_bubbles(_delta):
  for particle in particle_array:
    var airborne = false
    if !particle.collider:
      var circleCollider = CircleShape2D.new()
      circleCollider.radius = 3
      var areaCollider = AirCollider.getAirCollider(null, circleCollider)
      particle.sprite.add_child(areaCollider)
      particle.collider = areaCollider
    var areaCollisions = particle.collider.get_overlapping_areas()
    for collision in areaCollisions:
      if collision.collision_layer == 128:
        airborne = true
    if (airborne):
      particle.dy = 0
      if (randi() % 10 > 7):
        kill_particle(particle)
    # TODO have bubbles twitch? at the surface
    # kill vertical, killish horizontal, random horizontal movement
