extends Spatial

# Items pickup
const pickup_dist = 2
var hover: Spatial = null
var hand: Spatial = null
var hand_origin: Vector3

var using_tool = false
var is_game_over = false

var last_event = null

onready var ALL_EVENTS = [
	$Events/Leak,
	$Events/Leak2,
	$Events/LeakBoiler,
	$Events/BrokenCable,
	$Events/TempGauge,
	$Events/PressureGauge,
	$Events/Fire,
	$Events/Fire2,
	$Events/Puddle,
	$Events/PrankCall,
	$Events/SuperiorCall,
	$Events/HigherTempCall,
	$Events/LowerTempCall
]

onready var EVENTS_POOL = ALL_EVENTS

# Called when the node enters the scene tree for the first time.
func _ready():
	$Boilerco/BoilerAssembly/boiler/Handle.connect("select", self, "_on_tool_select")

func _input(event):
	var camera = $Camera

	if hand != null and not hand.is_in_group("Handset"):
		# move picked up item
		hand.visible = true
		hand.global_transform.origin = camera.project_position(event.position, pickup_dist)

func _process(_delta):
	if Input.is_action_just_pressed("Action") and not is_game_over:
		_on_tool_action_using()
	if Input.is_action_just_released("Action") and not is_game_over:
		if hand != null:
			_on_tool_action_done()
		elif hover != null:
			_on_tool_pickup()
	if Input.is_action_just_released("Cancel"):
		if is_game_over:
			if not $Usables/Phone/Decrocher.is_playing():
				Game.emit_signal("ChangeScene", "res://MainMenu/BackgroundMainMenu.tscn")
		elif hand != null:
			_on_tool_cancel()

func _on_tool_pickup():
	if hover.is_in_group("CoalPile"):
		# spawn coal
		hand = $Coal
	elif hover.is_in_group("PressureHandle"):
		$Boilerco/BoilerAssembly.release_pressure()
	elif hover.is_in_group("Handset"):
		hand = hover
		$Usables/Phone._on_phone_pickup()
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
	elif hand.is_in_group("Handset"):
		$Usables/Phone._on_phone_hang()
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
	if is_game_over:
		pass
	if hover != null:
		hover.scale = Vector3(1, 1, 1)
	hover = item
	if hover != null and hand == null:
		hover.scale = Vector3(1.1, 1.1, 1.1)

func _on_EventTimer_timeout():
	if is_game_over:
		pass
	var r_temperature = $Boilerco/BoilerAssembly.get_ratio_temperature()
	var r_pression = $Boilerco/BoilerAssembly.get_ratio_pressure()
	var pool = build_event_pool(r_temperature, r_pression)

	# remove last event
	if last_event != null:
		pool.erase(last_event)
	
	print("Pool : " + str(pool))

	if not pool.empty():
		var rand_index:int = randi() % pool.size()
		var event = pool[rand_index]

		last_event = event
		print("T:" + str(r_temperature) + " P:" + str(r_pression))
		print("Chosen : " + event.name)
		event.trigger_event()
	
func build_event_pool(temp, press):
	var cur_events = []
	for event in EVENTS_POOL:
		if event.is_activated():
			cur_events.append(event.name)
	var pool = []
	for event in EVENTS_POOL:
		if not event.name in cur_events and event.is_activable(temp, press, cur_events):
			pool.append(event)
	return pool

func game_over():
	if not is_game_over :
		is_game_over = true
		var phone = $Usables/Phone
		phone.clear_all_dialogue()
		phone.add_dialogue(["\nWhat is this mess!\nAre you unable to take care of a simple boiler?\nYOU'RE FIRED!"])
		phone._on_phone_pickup()
	
	
func _on_Phone_dialog_completed(fully):
	hand = null
	if is_game_over:
		Game.emit_signal("ChangeScene", "res://MainMenu/BackgroundMainMenu.tscn")
