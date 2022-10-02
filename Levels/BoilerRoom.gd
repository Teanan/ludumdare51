extends Spatial

# Items pickup
const pickup_dist = 2
var hover: Spatial = null
var hand: Spatial = null
var hand_origin: Vector3

var using_tool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Events/Leak.trigger_event()
	$Events/Leak2.trigger_event()
	$Events/LeakBoiler.trigger_event()
	$Events/BrokenCable.trigger_event()
	$Events/TempGauge.trigger_event()
	
	$Boilerco/BoilerAssembly/boiler/Handle.connect("select", self, "_on_tool_select")

func _input(event):
	var camera = $Camera

	if hand != null:
		# move picked up item
		hand.visible = true
		hand.global_transform.origin = camera.project_position(event.position, pickup_dist)

func _process(delta):
	if Input.is_action_just_pressed("Action"):
		_on_tool_action_using()
	if Input.is_action_just_released("Action"):
		if hand != null:
			_on_tool_action_done()
		elif hover != null:
			_on_tool_pickup()
	if Input.is_action_just_released("Cancel"):
		if hand != null:
			_on_tool_cancel()

func _on_tool_pickup():
	if hover.is_in_group("CoalPile"):
		# spawn coal
		hand = $Coal
	elif hover.is_in_group("PressureHandle"):
		$Boilerco/BoilerAssembly.release_pressure()
	else:
		# pickup highlighted item
		hand = hover
		hand_origin = hover.global_transform.origin
		hand.input_ray_pickable = false

func _on_tool_action_using():
	if hand != null and hand.is_in_group("Tool"):
		if hand.has_method("animate"):
			hand.animate(true)
		using_tool = true

func _on_tool_action_done():
	using_tool = false
	if hand.has_method("animate"):
		hand.animate(false)
	if hand.is_in_group("Coal"):
		$Boilerco/BoilerAssembly.add_coal()
		$Coal.visible = false
		hand = null
	#else:
	#	# place item
	#	hand.global_transform.origin.z = hand_origin.z
	#	hand = null

func _on_tool_cancel():
	if hand.has_method("animate"):
		hand.animate(false)
	if hand.is_in_group("Coal"):
		$Coal.visible = false
		hand = null
	else:
		# return picked up item to origin
		hand.global_transform.origin = hand_origin
		hand.scale = Vector3(1, 1, 1)
		hand.input_ray_pickable = true
		hand = null
		hover = null
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_tool_select(item: Spatial):
	if hover != null:
		hover.scale = Vector3(1, 1, 1)
	hover = item
	if hover != null and hand == null:
		hover.scale = Vector3(1.1, 1.1, 1.1)
