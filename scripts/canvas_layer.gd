extends CanvasLayer
@export var player : CharacterBody2D
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _process(delta: float) -> void:
	if player.get_node("Hand").holding == 1:
		$CardHand.visible = true
		$BunnyHand.visible = false
	elif player.get_node("Hand").holding == 2:
		$CardHand.visible = false
		$BunnyHand.visible = true
	
	$BunnyHand.get_node("Label").text = str(player.bunnies)
	
