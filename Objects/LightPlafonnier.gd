extends Spatial

onready var anim = $LightAnimation
onready var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()
	var animation_list = anim.get_animation_list()
	while true:
		var wait_time = random.randf_range(2.0, 10.0)
		var anim_speed = random.randf_range(0.5, 1)
		var anim_select = rand_range(0, animation_list.size() - 1)
		yield(get_tree().create_timer(wait_time),"timeout")
		anim.play(animation_list[anim_select], -1, anim_speed)
