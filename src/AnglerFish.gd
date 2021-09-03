extends Unit

var idle_timer: float = 0
var idle_timer_threshold: float
var alert_timer: float = 0
var alert_threshold: float = 5
var attack_cooldown: float = 5;
var attack_timer: float = 5;
var player: Node2D

func _init():
  maxspeed = 100
  friction = 0.99
  speed = 5

func _ready():
  state = "idle"
  $AnimatedSprite.playing = false
  idle_timer_threshold = randf() * 20
  player = $"/root/PlayerNode"

func _physics_process(delta):
  self.airborne = false
  match state:
    "dying":
      $CollisionPolygon2D.disabled = true
      $AnimatedSprite.animation = "dying"
    "idle":
      $AnimatedSprite.animation = "idle"
      if idle_timer > idle_timer_threshold:
        $AnimatedSprite.playing = true
      else:
        idle_timer += delta
    "alert":
      alert_timer += delta
      if alert_timer > alert_threshold:
        state = "seek"
      $AnimatedSprite.play("alert")
    "seek":
      attack_timer += delta
      $AnimatedSprite.animation = "seek"
      follow_player()
    "attack":
      attack_timer += delta
      $AnimatedSprite.playing = true
      $AnimatedSprite.animation = "attack"
    _:
      state = "idle"
  var collision = _move_and_collide(delta)
  if (collision): 
    print("hey I think we hit something")

func follow_player():
  if (!self.airborne):
    dv = position.direction_to(player.position)
  if (dv.x > 0):
    $AnimatedSprite.scale.x = -1
  else:
    $AnimatedSprite.scale.x = 1
    
  var distance = position.distance_to(player.position)
  if (distance < 50 && attack_timer >= attack_cooldown):
    state = "attack"
  pass

func _on_AnimatedSprite_animation_finished():
  match $AnimatedSprite.animation:
    "idle":
      $AnimatedSprite.playing = false
      idle_timer = 0
      idle_timer_threshold = randf() * 20
    "attack":
      attack_timer = 0
      state = "seek"
    _:
      pass

func _on_Area2D_body_entered(_body):
  if state == "idle":
    state = "alert"

func _on_Area2D_body_exited(_body):
  if state == "alert":
    state = "seek"
  pass
  
