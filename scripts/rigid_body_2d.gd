extends RigidBody2D

var speed = 700
var gone = false
func _ready() -> void:
	var animation_name = ["a", "b,", "c", "d", "e", "f"].pick_random()
	$AnimatedSprite2D.play(animation_name)

func _physics_process(delta):
	if gone == false:
		var collision = move_and_collide(transform.x * speed * delta)
		if collision:
			
			collided(collision.get_collider())		

		

func collided(body):
	if body.is_in_group("mobs") and gone == false:
		body.Health -= 1
		
		body.get_node("Hurt").pitch_scale = randfn(1, 0.1)
		body.get_node("Hurt").play()
		$Hit.play()
	gone = true
	await get_tree().create_timer(0.15).timeout
	queue_free()
