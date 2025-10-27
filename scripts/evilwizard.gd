extends CharacterBody2D
@export var Health: int = 10
@export var Bullet : PackedScene

var speed = 100
var dead = false
var cd = false

var killedplayer = false

var maxdistance = 50
func _ready():
	$AnimatedSprite2D.play()
	
func _physics_process(delta):
	if Health <= 0:
		if dead == false:
			dead = true
			var player = self.owner.find_child("Player")
			if player:
				player.score += 10
			$Death.visible = true
			$Death.play()
			$AnimatedSprite2D.visible = false
			$CollisionShape2D.disabled = true
			$DeathSfx.pitch_scale = randfn(1, 0.1)
			$DeathSfx.play(0.41)
			await get_tree().create_timer(1).timeout
			queue_free()
	elif self and self.owner:
		var player = self.owner.find_child("Player")
		if player:
			if self.owner.find_child("Dummy1", true, false):
				
				player = self.owner.find_child("Dummy1", true, false)
			
			var distance = self.global_position.distance_to(player.global_position)
			var direction = (player.global_position - self.global_position).normalized()
			if direction.x != 0:
				$AnimatedSprite2D.flip_h = direction.x < 0
					
			var collision = move_and_collide(direction * speed * delta)
			if collision:
				var normal = collision.get_normal()
				collided(collision.get_collider(), normal)
				
			if cd == false:
				cd = true
				for i in range(3):
					if player:
						shoot(player.global_position)
					await get_tree().create_timer(0.15).timeout
				await get_tree().create_timer(1).timeout
		
				cd = false
			
		
				

		
func shoot(pos):

	if owner.get_child_count() < 100:
		$Fire.pitch_scale = randfn(1.5, 0.1)
		$Fire.play(0.41)	
			
		var b = Bullet.instantiate()
		owner.add_child(b)
		b.global_position = self.global_position

		var dir = global_position.angle_to_point(pos)
		b.global_rotation = dir	
		
		
	
	
		
		
		
		
func collided(body, normal):
	if body.is_in_group("player"):
		if body.health > 0 and body.iframes == 0:
			body.health -= 1 
			body.iframes = 0.2
			body.velocity = -normal * 200
			body.move_and_slide()
	if body.is_in_group("dummy"):
		if body.health > 0:
			body.health -=1
			
			

				
