extends GeneralTool

func _on_mouse_entered():
	emit_signal("select", self)

func _on_mouse_exited():
	emit_signal("select", null)

func animate(play: bool):
	if play:
		$AnimationPlayer.play("extinguishing", -1.0, 1.5)
	else:
		$AnimationPlayer.play("RESET")
