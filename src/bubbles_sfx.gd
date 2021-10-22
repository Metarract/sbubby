extends AudioStreamPlayer

func _ready():
  randomize()
  pitch_scale = rand_range(0.4, 1.5)
  volume_db = rand_range(-20,-15)

func _on_bubbles_finished():
  queue_free()
