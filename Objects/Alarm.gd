extends Spatial

onready var anim = $AnimationPlayer

func start_alarm():
	anim.play("alarm")

func stop_alarm():
	anim.play("RESET")

func _ready():
	pass
