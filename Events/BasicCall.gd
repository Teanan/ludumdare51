extends Spatial

onready var PV = $"../../PV"
onready var Phone = $"../../Usables/Phone"

export (Array, String) var Dialog = []
export (int) var PV_lost = 0

func trigger_event():
	Phone.add_dialogue(Dialog)
	Phone.connect("dialog_completed", self, "_on_pickup")

func clear_event():
	Phone.disconnect("dialog_completed", self, "_on_pickup")

func _on_pickup(success):
	if not success:
		_on_failed_pickup()
	clear_event()

func _on_failed_pickup():
	PV.remove_pv(PV_lost)
