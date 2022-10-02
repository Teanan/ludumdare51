extends Spatial

onready var anim = $LightAnimation
onready var timer = $Timer
onready var random = RandomNumberGenerator.new()
var is_turned_on = true
var random_animation_list = ["Blink", "LongBlink"]


func _ready():
	random.randomize()

func turn_on():
	if not is_turned_on:
		anim.play_backwards("TurnOff")
		is_turned_on = true

func turn_off():
	if is_turned_on:
		anim.play("TurnOff")
		is_turned_on = false

func _on_Timer_timeout():
	# Restart timer first
	timer.wait_time = random.randf_range(2.0, 10.0)
	timer.start()

	# Then trigger blink if light is turned on
	if is_turned_on:
		var anim_speed = random.randf_range(0.5, 1)
		var anim_select = rand_range(0, random_animation_list.size() - 1)
		anim.play(random_animation_list[anim_select], -1, anim_speed)
