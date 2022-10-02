extends GeneralTool

var is_handled = false

func animate(play: bool):
	if play:
		$AnimationPlayer.play("handling", -1.0, 1.5)
		is_handled = true
	else:
		if is_handled:
			$AnimationPlayer.play_backwards("handling")
			is_handled = false
		else:
			$AnimationPlayer.play("RESET")
