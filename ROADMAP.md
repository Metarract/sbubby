## Road Map

1. Player character x
1. Movement scripts x
1. Some terrain x
1. Camera movement
    - easing x
    - look-ahead
        - drag point from player to look ahead distance
        - separate x and y distances
1. Terrain collision + vector flip when colliding x
1. Torpedo + torpedo attack x
    - kill_instance x
    - wall_collision x
1. Hit detection with missile / enemy x
1. Enemy death
1. Enemy with simple AI to approach player x
1. Enemy drops item
1. Item needs armor_quality (factor of 100)
1. Item adjusts player armor if quality is high enough
1. ITERATE

## Other Details

### Accessibility
- Input Mapping
  - `Input.add_joy_mapping`
- Color modifications

### Lighting
- Canvas layer modulate darkness
- some weird glow around him that modulates darkness, but OPPOSITE wow
- should have a global(??) value that the main lighting eases into
    1. ship descends
    1. value gets decremented with it
    1. value receives flat modifiers from other sources (if we're in a cave, flat modifier of something or other)
    1. lighting eases/approaches value

## Extras
1. Ambient NPCs
1. Normal Maps? X
1. Idle Animations
