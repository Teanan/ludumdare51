extends Spatial

onready var PV = $"../../PV"
onready var Phone = $"../../Usables/Phone"

export (Array, String) var Dialog = []
export (int) var PV_lost = 0

var activated = false

func trigger_event():
	clear_event()
	Phone.add_dialogue(Dialog.duplicate(true))
	activated = true
	Phone.connect("dialog_completed", self, "_on_pickup")

func clear_event():
	activated = false
	Phone.disconnect("dialog_completed", self, "_on_pickup")

func _on_pickup(success):
	clear_event()
	if not success:
		_on_failed_pickup()

func _on_failed_pickup():
	PV.remove_pv(PV_lost)

func is_activated():
	return activated
	
func is_activable(_temperature, _pressure, _cur_events):
	return true
	
