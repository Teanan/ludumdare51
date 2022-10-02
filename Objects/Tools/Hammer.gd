extends GeneralTool

onready var anim = $AnimationPlayer

func animate(play: bool):
	if play:
		anim.play("hammering", -1.0, 2.0)
	else:
		anim.play("RESET")
