extends GeneralTool

onready var anim = $AnimationPlayer

func animate(play: bool):
	if play:
		anim.play("taping", -1.0, 2.0)
	else:
		anim.play("RESET")

func play_sfx(play: bool):
	if $SFX.playing != play:
		$SFX.playing = play
