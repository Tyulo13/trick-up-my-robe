extends AnimatedSprite2D
@export var Bullet : PackedScene
@export var Bunny : PackedScene
@export var holding : int = 1
var cd = false
var throwcd = false
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if owner.health > 0:
		var dir = (get_global_mouse_position() - self.global_position).normalized()
		self.flip_h = dir.x > 0
		look_at(get_global_mouse_position())
		if dir.x < 0:
			self.rotate(deg_to_rad(180))
			
			
		
		if Input.is_action_just_pressed("swapitem"):
			if cd == false:
				holding += 1
				$Equip.pitch_scale = randfn(1, 0.1)
				$Equip.play()
				if holding > 2:
					holding = 1
				if holding == 1:
					animation = "idle"
					owner.get_node("Hat").visible = true
					
				elif holding == 2:
					owner.get_node("Hat").visible = false
					play("bunnyequip")
		if owner.bunnies <= 0 and holding == 2:
			play("nobunnies")

				
		if Input.is_action_just_pressed("fire"):
			if holding == 1:
				shoot()
			elif holding == 2:
				throw()
		
func throw():
	if throwcd == false and cd == false and owner.invis == false and owner.bunnies > 0:
		throwcd = true
		owner.bunnies -= 1
		cd = true
		play("throwingbunny")
		$CardThrow.pitch_scale = randfn(0.5, 0.1)
		$CardThrow.play()	
		var b = Bunny.instantiate()
		owner.owner.add_child(b)
		b.player = self.owner
		b.global_position = self.global_position

		var dir = global_position.angle_to_point(get_global_mouse_position())
		b.global_rotation = dir	
		
		await get_tree().create_timer(0.1).timeout
		cd = false
		await get_tree().create_timer(0.05).timeout
		
		
		
		throwcd = false
		
func shoot():
	if cd == false and owner.invis == false:
		cd = true
		for i in range(owner.burst):
			self.play("fire")

			$CardThrow.pitch_scale = randfn(2, 0.1)
			$CardThrow.play()	
			
			var b = Bullet.instantiate()
			owner.owner.add_child(b)
			b.global_position = self.global_position

			var dir = global_position.angle_to_point(get_global_mouse_position())
			b.global_rotation = dir	
			
			await get_tree().create_timer(0.15).timeout
		
		
		
		
		await get_tree().create_timer(0.5).timeout
		
		cd = false
		
