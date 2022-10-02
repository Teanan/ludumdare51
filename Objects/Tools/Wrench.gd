extends GeneralTool

func animate(play: bool):
	if play:
		$AnimationPlayer.play("wrenching", -1.0, 3.0)
	else:
		$AnimationPlayer.play("RESET")
