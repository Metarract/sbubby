extends Node2D
class_name Emitter

export(bool) var emitting = true
export(bool) var local_coords = false
export(int) var max_particles = 50
export(bool) var force_emit = false
export(Texture) var texture:Texture
export(bool) var texture_randomness = false
export(int) var region_width = 0
export(int) var region_height = 0

export(float) var lifetime = 1
export(bool) var lifetime_randomness = true
export(float) var spread = 0
export(float) var gravity:float = 0
export(float, 0, 359, 0.1) var angle = 0
export(float) var initial_velocity = 0
export(bool) var initial_velocity_randomness = false
export(float, 0, 1, 0.01) var damping = 0
export(int) var particle_z_index = 0
export(bool) var particle_z_index_as_relative = true

var particle_array: = []
var dv:Vector2 = Vector2(0, 0)

var atlas_offsets:Vector2 = Vector2.ZERO

func _ready():
  randomize()
  if (texture.get_class() == "AtlasTexture" && texture_randomness):
    slice_atlas()
  # set seed on this emitter

func _process(delta):
  # TODO do something with different texture types, doofus
  if (texture.get_class() == "AtlasTexture" && texture_randomness):
    texture = texture as AtlasTexture
    var x_offset = floor(randf() * atlas_offsets.x) * region_width
    var y_offset = floor(randf() * atlas_offsets.y) * region_height
    texture.region = Rect2(Vector2(x_offset, y_offset), Vector2(region_width, region_height))
  var particle_dict = gen_particle()
  if (particle_dict):
    particle_array.append(particle_dict)
  process_particles(delta)

func slice_atlas():
  texture = texture as AtlasTexture
  var text_width = texture.atlas.get_width()
  var text_height = texture.atlas.get_height()
  var horizontal_slices = text_width/region_width
  var vertical_slices = text_height/region_height
  atlas_offsets = Vector2(horizontal_slices, vertical_slices)
  print(atlas_offsets)

func gen_particle():
  # if we don't have room / we're not emitting, get outta here
  if ((particle_array.size() >= max_particles && !force_emit) || !emitting):
    return
  var sprite = Sprite.new()
  var tempTex;
  if (texture.get_class() == "AtlasTexture"):
    tempTex = AtlasTexture.new()
    tempTex.atlas = texture.atlas
    tempTex.region = texture.region
  else:
    tempTex = texture
  sprite.texture = tempTex
  sprite.z_as_relative = particle_z_index_as_relative
  sprite.z_index = particle_z_index
  # if we're local, attach to parent and respect parent coords. if we're global, attach to top node and respect top node coords
  if (local_coords):
    sprite.position = position
    add_child(sprite)
  else:
    sprite.position = to_global(position)
    var root = get_tree().get_root()
    root.add_child(sprite)
  # determine base values vis a vis randomness
  if (spread > 0):
    var spread_angle = randf() * 360
    sprite.position.x += cos(spread_angle) * spread
    sprite.position.y += sin(spread_angle) * spread

  var temp_lifetime:float
  if (lifetime_randomness):
    temp_lifetime = randf() * lifetime
  else:
    temp_lifetime = lifetime
  
  var temp_velocity:float
  if (initial_velocity_randomness):
    temp_velocity = randf() * initial_velocity
  else:
    temp_velocity = initial_velocity
  var particle:Dictionary = {
    "sprite": sprite,
    "collider": false,
    "lifetime": temp_lifetime,
    "velocity": temp_velocity  * get_parent().scale, # TODO this needs to just get the sign
    "direction": Vector2(cos(angle), sin(angle)),
    "dx": 0,
    "dy": 0,
  }
  if (particle_array.size() >= max_particles):
    kill_particle(particle_array[0])
  return particle

func process_particles(delta):
  for particle in particle_array:
    # if the particle expired last frame, kill it everywhere and move to next item in loop
    if (particle.lifetime <= 0):
      kill_particle(particle);
      continue
    # let's add up all of our dumb vectors yay
    particle.dy += gravity
    # get vector from angle
    dv = (particle.direction * particle.velocity + Vector2(0, particle.dy)) * delta
    dv *= (1 - damping)
    particle.lifetime -= delta
    particle.sprite.position += dv # TODO node2d.translate?

func kill_particle(particle):
    particle.sprite.queue_free()
    particle_array.erase(particle)
