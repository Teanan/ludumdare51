extends Spatial

onready var anim = $LightAnimation
onready var anim_bobble = $BobbleAnimation
onready var timer = $Timer
onready var random = RandomNumberGenerator.new()
var is_turned_on = true
var random_animation_list = ["Blink", "LongBlink"]
var mouse_over = false

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

func _process(_delta):
	if mouse_over and Input.is_action_just_pressed("Action"):
		anim_bobble.play("FastBobble")

func _on_LightPlafonnier_mouse_entered():
	mouse_over = true

func _on_LightPlafonnier_mouse_exited():
	mouse_over = false

func _on_BobbleAnimation_animation_finished(anim_name):
	if anim_name == "FastBobble":
		anim_bobble.play("Bobble")
