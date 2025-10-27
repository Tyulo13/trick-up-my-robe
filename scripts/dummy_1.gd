class_name Dummy1 extends StaticBody2D
@export var health: int = 1

var destroyed = false

func _ready():
	$Smoke.visible = true
	$Smoke.play("default")
	$Smoke.self_modulate.a = 0.4
	await get_tree().create_timer(3).timeout
	
	destroy()
	
func _process(delta: float) -> void:
	if health <= 0:
		destroy()
	
	

func destroy():
	if destroyed == false:
		destroyed = true
		$AnimatedSprite2D.play("destroy")
		await get_tree().create_timer(0.3).timeout
		self.queue_free()


func _on_smoke_animation_finished() -> void:
	$Smoke.visible = false
