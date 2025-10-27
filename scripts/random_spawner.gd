extends Node2D

@export var Bunny: PackedScene
@export var Health: PackedScene
@export var Cards: PackedScene

var timepassed = 0

func _process(delta: float) -> void:
	var randx = randf_range(200,2000)
	var randy = randf_range(-20,-800)
	self.global_position = Vector2(randx, randy)
	
	timepassed += delta * randf_range(0.5,1.5)
	
	if timepassed > 15:
		spawn()
		timepassed = 0
		
func spawn():
	var integ = randi_range(1,3)
	var item = null
	if integ == 1:
		item = Bunny.instantiate()
	elif integ == 2:
		item = Health.instantiate()
	else:
		item = Cards.instantiate()
		
	item.set_owner(owner)
	owner.add_child(item)
	item.global_position = self.global_position
