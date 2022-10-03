extends Spatial

class_name GeneralGauge

export (float) var MAX_ANGLE_DEG = -90.0
export (float) var MIN_ANGLE_DEG = 90.0

export (float) var MAX_VALUE = 100.0
export (float) var MIN_VALUE = 0.0
export (float) var ALLOWED_JITTER_VALUE = 5.0

export (float) var CONVERGENCE_SPEED = 25.0

export (bool) var BUGGED = false

var current_value = 0
var target_value = 50

onready var rotation_node = get_node("gauge_rotation")

func set_value(value):
	if value > MAX_VALUE:
		target_value = MAX_VALUE
	elif value < MIN_VALUE:
		target_value = MIN_VALUE
	else:
		target_value = value

func _ready():
	rotation_node.rotation_degrees.z = MIN_ANGLE_DEG

func _process(delta):
	if BUGGED:
		rotation_node.rotation_degrees.z -= 1000 * delta
	else:
		var jitterred_target_value = target_value + rand_range(-ALLOWED_JITTER_VALUE, ALLOWED_JITTER_VALUE)
		if jitterred_target_value < current_value:
			current_value = current_value - delta * CONVERGENCE_SPEED
		else:
			current_value = current_value + delta * CONVERGENCE_SPEED
	
		#print(current_value)
		var angle = MiscFunc.map(current_value, MIN_VALUE, MAX_VALUE, MIN_ANGLE_DEG, MAX_ANGLE_DEG)
		#print(angle)
	
		rotation_node.rotation_degrees.z = angle

