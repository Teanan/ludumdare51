extends StaticBody

signal select(node)

func _on_Wrench_mouse_entered():
	emit_signal("select", self)

func _on_Wrench_mouse_exited():
	emit_signal("select", null)

func animate(play: bool):
	if play:
		$AnimationPlayer.play("wrenching", -1.0, 3.0)
	else:
		$AnimationPlayer.play("RESET")
