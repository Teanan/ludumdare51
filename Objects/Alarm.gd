extends Spatial

func start_alarm():
	$AnimationPlayer.play("alarm")

func stop_alarm():
	$AnimationPlayer.play("RESET")

func _ready():
	pass
