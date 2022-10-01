extends Spatial

onready var anim = $LightAnimation
onready var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()
	while true:
		var wait_time = random.randf_range(2.0, 10.0)
		var anim_speed = random.randf_range(0.5, 1)
		yield(get_tree().create_timer(wait_time),"timeout")
		anim.play("Blink", -1, anim_speed)
