extends Spatial

export (float) var temperature = 25.0
export (float) var pressure = 1.0
export (float) var coal = 0.0

onready var anim = $boiler/AnimationPlayer
onready var fire_particles = $boiler/FireParticles

const min_temp = 12
const max_temp = 125
const max_pressure = 4

const MIN_FIRE_SCALE = Vector3(0, 1, 2.6)
const MAX_FIRE_SCALE = Vector3(8, 2.3, 2.6)

var door_opened = false

#func _ready():
#	$PressureGauge.CONVERGENCE_SPEED = 100

func _on_BoilerTick_timeout():
	if coal > 0:
		coal = coal - 1
		temperature = temperature + 5
		pressure = pressure + 0.004 * temperature

	temperature = clamp(temperature - 2, min_temp, max_temp)
	pressure = clamp(pressure - 0.05, 0, max_pressure)
	
	$boiler/Gauge.set_value((temperature - min_temp) * 100 / (max_temp - min_temp))
	#$PressureGauge.set_value(pressure * 100 / (max_pressure))
	var temperature_ratio = (temperature - min_temp) / (max_temp - min_temp)
	fire_particles.scale = MIN_FIRE_SCALE.linear_interpolate(MAX_FIRE_SCALE, temperature_ratio)
	


func add_coal():
	if door_opened:
		coal = coal + 10
		close_door()

func open_door():
	door_opened = true
	anim.play("open_door")

func close_door():
	door_opened = false
	anim.play_backwards("open_door")

func _on_BoilerAssembly_mouse_entered():
	if get_parent().get_parent().hand != null and \
		get_parent().get_parent().hand.is_in_group("Coal"):
		open_door()

func _on_BoilerAssembly_mouse_exited():
	if door_opened:
		close_door()
