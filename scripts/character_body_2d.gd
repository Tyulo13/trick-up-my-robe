class_name Player1 extends CharacterBody2D
@export var Dummy: PackedScene
@export var invis: bool = false
@export var health: int = 25
@export var burst: int = 1
@export var bunnies: int = 3
@export var iframes: float = 0
@export var score: int = 0

var mspeed : float = 3
var maxspd: float = 4
var dodgecd: bool = false
var dead = false

var lasthp = 10000
var lastbunny = 10000
var lastcards = 10000

func _ready():
	randomize()
	lasthp = health
	lastbunny = bunnies
	lastcards = burst
	pass


func _process(delta: float):
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	if health <= 0:
		if dead == false:
			dead = true
			$Death.visible = true
			$Death.play()
			$Body.visible = false
			$Hand.visible = false
			$Hat.visible = false
			$CollisionShape2D.disabled = true
			
			$DeathSfx.pitch_scale = randfn(1, 0.1)
			$DeathSfx.play(0.41)
			await get_tree().create_timer(2.5).timeout
			get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")
	else:
		if lasthp > health:
			lasthp = health
			var random_child = $Sounds.get_children().pick_random()
			if random_child:
				random_child.pitch_scale = randfn(1, 0.1)
				random_child.play()
		elif lasthp < health:
			lasthp = health
			$Medkit.play()
		if lastbunny < bunnies:
			lastbunny = bunnies
			$PickUp.play(0.27)
		if lastcards < burst:
			lastcards = burst
			$PickUp.play(0.27)
		
		var spd = velocity.length()
		velocity = velocity.lerp(direction * mspeed, 0.1) 
		
		if iframes > 0:
			$Body.modulate = Color(1.5, 0.5, 0.5) 
			iframes -= delta
		else:
			$Body.modulate = Color(1, 1, 1) 
			iframes = 0
		
		if spd < 2:
			$Body.animation = "idle"
			$Hat.animation = "idle"
		else:
			$Body.animation = "walk"
			$Hat.animation = "walk"
		$Body.play()
		$Hat.play()
		if direction.x != 0:
			$Body.flip_h = direction.x < 0
			$Hat.flip_h = direction.x < 0	
		
		
		velocity = velocity.clamp(Vector2(-maxspd,-maxspd), Vector2(maxspd,maxspd)) 
		$Body.scale.x = lerp($Body.scale.x, 1.0, 0.1)
		$Body.scale.y = lerp($Body.scale.y, 1.0, 0.1)
		
		if Input.is_action_pressed("dodge"):
			if dodgecd == false:
				dodgecd = true
				invis = true
				$SmokeBomb.pitch_scale = randfn(1, 0.1)
				$SmokeBomb.play()
				var b = Dummy.instantiate()
				owner.add_child(b)
				b.global_position = self.global_position
				b.find_child("AnimatedSprite2D").flip_h = $Body.flip_h
				
				$Body.self_modulate.a = 0.3
				$Hat.self_modulate.a = 0.3
				$Hand.self_modulate.a = 0.3
				
				await get_tree().create_timer(0.7).timeout
				
				$Body.self_modulate.a = 1
				$Hat.self_modulate.a = 1
				$Hand.self_modulate.a = 1
				invis = false
				await get_tree().create_timer(5).timeout
				dodgecd = false
				
				
		
		
			
		
	
func _physics_process(delta: float):
	var collision = move_and_collide(velocity)
	if collision:
		
		##$Splat.pitch_scale = randfn(1, 0.3)
		##$Splat.play()
		var normal = collision.get_normal()
		
		$Body.scale.y = 1 + abs(normal.x)/5
		$Body.scale.x = 1 + abs(normal.y)/5
		velocity = velocity.bounce(normal)
		
	
