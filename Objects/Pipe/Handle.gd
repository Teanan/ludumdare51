extends GeneralTool

func animate(play: bool):
	if play:
		$AnimationPlayer.play("handling", -1.0, 1.5)
	else:
		$AnimationPlayer.play("RESET")
