extends Spatial

onready var PV = $"../../PV"
onready var Phone = $"../../Usables/Phone"
onready var BoilerAss = $"../../Boilerco/BoilerAssembly"

export (Array, String) var Dialog_start = []
export (Array, String) var Dialog_success = []
export (Array, String) var Dialog_failed = []
export (int) var PV_lost = 0
export (bool) var higher_temp = true

var initial_temperature = 0

var activated = false

func trigger_event():
	_reset_event()
	activated = true
	initial_temperature = BoilerAss.temperature
	Phone.add_dialogue(Dialog_start)
	Phone.connect("dialog_completed", self, "_on_pickup")

func _on_pickup(success):
	Phone.disconnect("dialog_completed", self, "_on_pickup")
	print("Pickup Temperature demand : "+ str(success))
	if success:
		initial_temperature = BoilerAss.temperature
		$Timer.start()
	else:
		_on_failed()

func _on_failed():
	PV.remove_pv(PV_lost)

func _on_Timer_timeout():
	print("Timer!")
	if (higher_temp and BoilerAss.temperature > initial_temperature) or \
		(not higher_temp and BoilerAss.temperature < initial_temperature):
		if not Dialog_success.empty():
			Phone.add_dialogue(Dialog_success)
	else:
		if not Dialog_failed.empty():
			Phone.add_dialogue(Dialog_failed)
		_on_failed()
	_reset_event()

func _reset_event():
	$Timer.stop()
	initial_temperature = 0
	Phone.disconnect("dialog_completed", self, "_on_pickup")
	activated = false


func is_activated():
	return activated
	
func is_activable(temperature, _pressure, _cur_events):
	return (higher_temp and temperature < 0.6) or (not higher_temp and temperature > 0.4)
	
