extends Button
var pressede = false

func _on_pressed() -> void:
	if pressede == false:
		pressede = true
		$Laugh.play()
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
