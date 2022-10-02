extends Spatial

func start_alarm():
	$AnimationPlayer.play("alarm")
	$OmniLight.visible = true

func stop_alarm():
	$AnimationPlayer.play("RESET")
	$OmniLight.visible = false

func _ready():
	pass
