extends Spatial

export (float) var temperature = 25
export (float) var pressure = 1
export (float) var coal = 0

const min_temp = 12
const max_temp = 125
const max_pressure = 4

func _ready():
	pass

func _on_BoilerTick_timeout():
	if coal > 0:
		coal = coal - 1
		temperature = temperature + 5
		pressure = pressure + 0.004 * temperature

	temperature = clamp(temperature - 2, min_temp, max_temp)
	pressure = clamp(pressure - 0.05, 0, max_pressure)
	
	$Gauge.set_value((temperature - min_temp) * 100 / (max_temp - min_temp))
