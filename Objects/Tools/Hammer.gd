extends GeneralTool

func animate(play: bool):
	if play:
		$AnimationPlayer.play("hammering", -1.0, 2.0)
	else:
		$AnimationPlayer.play("RESET")
