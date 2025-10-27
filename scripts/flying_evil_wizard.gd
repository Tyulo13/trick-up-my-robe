extends CharacterBody2D
@export var Health: int = 10
@export var Bullet : PackedScene

var speed = 150
var dashingspeed = 15
var dead = false
var cd = false
var dashing = null
var staring = false

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
				player.score += 25
			$Death.visible = true
			$Death.play()
			$AnimatedSprite2D.visible = false
			$Sprite2D.visible = false
			$AviatorGoggles.visible = false
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
				$AviatorGoggles.flip_h  = direction.x < 0
				$Sprite2D.flip_h  = direction.x < 0
				$Sprite2D.flip_v  = direction.x < 0
				
			if staring:
				look_at(player.global_position)
				if direction.x < 0:
					self.rotate(deg_to_rad(180))
			if not dashing:
				if not staring:
					var collision = move_and_collide(direction * speed * delta)
					if collision:
						var normal = collision.get_normal()
						collided(collision.get_collider(), normal)	
			else:
				
				var collision = move_and_collide(dashing * 100 * dashingspeed * delta)
				dashingspeed -= (delta * 40)
				if collision:
					var normal = collision.get_normal()
					collided(collision.get_collider(), normal)	
				
			if cd == false:
				cd = true
				
				staring = true
				await get_tree().create_timer(0.5).timeout
				staring = false
				player = self.owner.find_child("Player")
				if player:
					if self.owner.find_child("Dummy1", true, false):
						
						player = self.owner.find_child("Dummy1", true, false)
					
					direction = (player.global_position - self.global_position).normalized()
					
				dashing = direction
				dashingspeed = 15
				await get_tree().create_timer(0.35).timeout
				dashing = null
				rotation = 0
				await get_tree().create_timer(1).timeout
				cd = false
			
		
				

		

	
		
	
	
		
		
		
		
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
			
			

				
