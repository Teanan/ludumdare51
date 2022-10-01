extends Spatial


const MAX_ANGLE_DEG = -90
const MIN_ANGLE_DEG = 90

const MAX_VALUE = 100
const MIN_VALUE = 0
const ALLOWED_JITTER_VALUE = 5

const CONVERGENCE_SPEED = 25

var current_value = 0
var target_value = 50
var jitterred_target_value = 52

onready var rotation_node = get_node("gauge_rotation")

func map(value, fromLow, fromHigh, toLow, toHigh):
	return (value - fromLow) * (toHigh - toLow) / (fromHigh - fromLow) + toLow;

func set_value(value):
	if value > MAX_VALUE:
		target_value = MAX_VALUE
	elif value < MIN_VALUE:
		target_value = MIN_VALUE
	else:
		target_value = value

func _ready():
	rotation_node.rotation_degrees.z = MIN_ANGLE_DEG

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	jitterred_target_value = target_value + rand_range(-ALLOWED_JITTER_VALUE, ALLOWED_JITTER_VALUE)
	if jitterred_target_value < current_value:
		current_value = current_value - delta * CONVERGENCE_SPEED
	else:
		current_value = current_value + delta * CONVERGENCE_SPEED
	
	#print(current_value)
	var angle = map(current_value, MIN_VALUE, MAX_VALUE, MIN_ANGLE_DEG, MAX_ANGLE_DEG)
	#print(angle)
	
	rotation_node.rotation_degrees.z = angle
