extends GeneralTool

onready var anim = $AnimationPlayer

func animate(play: bool):
	if play:
		anim.play("wrenching", -1.0, 3.0)
	else:
		anim.play("RESET")

func play_sfx(play: bool):
	if $SFX.playing != play:
		$SFX.playing = play
