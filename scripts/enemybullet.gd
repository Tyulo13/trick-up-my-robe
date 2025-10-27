extends RigidBody2D

var speed = 350
var gone = false

func _physics_process(delta):
	$AnimatedSprite2D.rotate(deg_to_rad(delta*300))
	if gone == false:
		var collision = move_and_collide(transform.x * speed * delta)
		if collision:
			
			collided(collision.get_collider())		

		

func collided(body):
	if gone == false:
			
		if body.is_in_group("player"):
			if body.health > 0 and body.iframes == 0:
				body.health -= 1 
				body.iframes = 0.2
		if body.is_in_group("dummy"):
			if body.health > 0:
				body.health -=1
	gone = true
	queue_free()
