extends RigidBody2D

var speed = 700
var gone = false
@export var player: CharacterBody2D

func _physics_process(delta):
	$AnimatedSprite2D.rotate(deg_to_rad(delta*300))
	if gone == false:
		var collision = move_and_collide(transform.x * speed * delta)
		if collision:
			
			collided(collision.get_collider())		

		

func collided(body):
	if body.is_in_group("mobs") and gone == false:
		body.Health -= 2
		
		body.get_node("Hurt").pitch_scale = randfn(1, 0.1)
		body.get_node("Hurt").play()
	var overlapping_bodies = $Area2D.get_overlapping_bodies()
	for obj in overlapping_bodies:
		if obj.is_in_group("mobs"):
			obj.Health -= 10
			obj.get_node("Hurt").pitch_scale = randfn(1, 0.1)
			obj.get_node("Hurt").play()
			var normal = (obj.global_position - self.global_position).normalized()
			obj.velocity = normal * 1000
			obj.move_and_slide()
	if player:
		player.get_node("Camera2D").shaking = true
	$Explosion.play()
	$Explosion.rotation = randf_range(-180.0,180.0)
	$Hit.pitch_scale = randfn(1, 0.1)
	$Hit.play(4.15)
	$AnimatedSprite2D.visible = false
	freeze = true
	gone = true
	await get_tree().create_timer(1).timeout
	queue_free()
