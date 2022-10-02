extends Spatial

export (float) var temperature = 25.0
export (float) var pressure = 1.0
export (float) var coal = 0.0

onready var anim = $boiler/AnimationPlayer
onready var fire_particles = $boiler/FireParticles
onready var PressureGauge = $"../LargeGauge"
onready var CoalIcon = $boiler/ToolIcon
onready var PV = $"../../PV"

const min_temp = 12
const max_temp = 125
const min_pressure = 0
const max_pressure = 4

const MAX_FIRE_COAL_RATIO = 50
const MIN_FIRE_SCALE = Vector3(1, 1, 2.6)
const MAX_FIRE_SCALE = Vector3(8, 2.3, 2.6)

const MAX_PARTICULES_AMOUNT = 200

var door_opened = false

func _ready():
	CoalIcon.get_node("Tools/Coal").visible = true
	CoalIcon.visible = false
	PressureGauge.CONVERGENCE_SPEED = 100
	fire_particles.scale = MIN_FIRE_SCALE.linear_interpolate(MAX_FIRE_SCALE, 0)

func _on_BoilerTick_timeout():
	if coal > 0:
		coal = coal - 1
		if pressure > 0.5:
			temperature = temperature + 5
		pressure = pressure + 0.004 * (20 + temperature)

	temperature = clamp(temperature - 2, min_temp, max_temp)
	pressure = clamp(pressure - 0.05, 0, max_pressure)
	
	if temperature >= 50 and temperature <= 100:
		PV.add_pv(1)
	if temperature < 25 and temperature > 110:
		PV.remove_pv(1)
	
	$boiler/Gauge.set_value((temperature - min_temp) * 100 / (max_temp - min_temp))
	PressureGauge.set_value(pressure * 100 / (max_pressure))
	scale_fire()

func scale_fire():
	var old_scale = fire_particles.scale
	var coal_ratio = min(coal, MAX_FIRE_COAL_RATIO)  / MAX_FIRE_COAL_RATIO
	var dest_scale = MIN_FIRE_SCALE.linear_interpolate(MAX_FIRE_SCALE, coal_ratio)
	fire_particles.scale = old_scale + (dest_scale - old_scale) * 0.3


func release_pressure():
	print(pressure)
	$boiler/Handle.animate(true)
	$Exhaust/CPUParticles.amount = clamp((MAX_PARTICULES_AMOUNT * pressure) / max_pressure, 1, MAX_PARTICULES_AMOUNT)
	$Exhaust/CPUParticles.emitting = true
	pressure = min_pressure

func add_coal():
	if door_opened:
		coal = coal + 10
		close_door()
		CoalIcon.visible = false

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
	if coal <= 0:
		CoalIcon.visible = true

func _on_BoilerAssembly_mouse_exited():
	if door_opened:
		close_door()
	CoalIcon.visible = false
