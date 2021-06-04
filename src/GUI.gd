extends CanvasLayer

func _on_Player_depth_changed(depth):
  if (depth < 0):
    depth = 0
  $depth.text = "Depth: " + String(depth)

func _on_Player_armor_changed(armor):
  if (armor < 0):
    armor = 0
  $armor.text = "Armor: " + String(ceil(armor))

func _on_Player_crush_depth_changed(crush_depth):
  if (crush_depth < 0):
    crush_depth = 0
  $crush_depth.text = "Crush Depth: " + String(crush_depth)
