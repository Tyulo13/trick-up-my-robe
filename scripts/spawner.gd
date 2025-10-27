extends Sprite2D

@export var wizard : PackedScene
@export var flyingwizard : PackedScene
@export var pig : PackedScene
@export var player : CharacterBody2D
@export var starttime : int = 1
#@export var dragon : PackedScene
var difficulty = 0.1

var wizardspawntime = 10
var flyingspawntime = 60
var pigspawntime = 180

func _ready() -> void:
	wizardspawntime *= starttime
	flyingspawntime *= starttime
	pigspawntime *= starttime
	
func _process(delta):
	if owner.get_child_count() < 300:
		difficulty += delta * 0.01
		
		wizardspawntime -= difficulty * delta * randf_range(0.5,5)
		flyingspawntime -= difficulty * delta * randf_range(0.5,5)
		pigspawntime -= difficulty * delta * randf_range(0.5,5)
		
		
		if wizardspawntime <= 0:
			wizardspawntime = 25
			var enemy = wizard.instantiate()
			owner.add_child(enemy)
			enemy.set_owner(owner)
			enemy.global_position = global_position

		if flyingspawntime <= 0:
			flyingspawntime = 60
			var enemy = flyingwizard.instantiate()
			owner.add_child(enemy)
			enemy.set_owner(owner)
			enemy.global_position = global_position

		if pigspawntime <= 0:
			pigspawntime = 500
			var enemy = pig.instantiate()
			owner.add_child(enemy)
			enemy.set_owner(owner)
			enemy.global_position = global_position

		
