extends GeneralTool

onready var anim = $AnimationPlayer

func animate(play: bool):
	if play:
		anim.play("extinguishing", -1.0, 1.5)
	else:
		anim.play("RESET")
