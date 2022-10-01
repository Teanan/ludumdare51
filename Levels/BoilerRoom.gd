extends Spatial

# Items pickup
const pickup_dist = 2.5
var hover: Spatial = null
var hand: Spatial = null
var hand_origin: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	var camera = $Camera

	if hand != null:
		# move picked up item
		hand.global_transform.origin = camera.project_position(event.position, pickup_dist)

func _process(delta):
	if Input.is_action_just_released("Action"):
		if hand != null:
			# place item
			hand.global_transform.origin.z = hand_origin.z
			hand = null
		elif hover != null:
			# pickup highlighted item
			hand = hover
			hand_origin = hover.global_transform.origin
	if Input.is_action_just_released("Cancel"):
		if hand != null:
			# return picked up item to origin
			hand.global_transform.origin = hand_origin
			hand.scale = Vector3(1, 1, 1)
			hand = null
			hover = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_tool_select(item: Spatial):
	if hover != null:
		hover.scale = Vector3(1, 1, 1)
	hover = item
	if hover != null:
		hover.scale = Vector3(1.1, 1.1, 1.1)
