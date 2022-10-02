extends GeneralTool

onready var anim = $AnimationPlayer

func animate(play: bool):
	if play:
		anim.play("wrenching", -1.0, 3.0)
	else:
		anim.play("RESET")
