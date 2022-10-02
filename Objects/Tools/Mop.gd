extends GeneralTool

onready var anim = $AnimationPlayer

func animate(play: bool):
	if play:
		anim.play("mopping", -1.0, 2.0)
	else:
		anim.play("RESET")
