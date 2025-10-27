extends Camera2D

@export var randomStrength: float = 15
@export var shakeFade: float = 5.0
@export var shaking: bool = false

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0

func _process(delta):
	if shaking == true:
		shaking = false
		applyShake()
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		offset = randomOffset()
	

func applyShake():
	shake_strength = randomStrength
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength),rng.randf_range(-shake_strength, shake_strength))
