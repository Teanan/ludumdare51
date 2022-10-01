extends Spatial

onready var anim = $AnimationPlayer

func _ready():
	while true:
		var wait_time = rand_range(2.0, 10.0)
		var anim_speed = rand_range(0.5, 2)
		yield(get_tree().create_timer(wait_time),"timeout")
		anim.play("Blink", -1, anim_speed)
