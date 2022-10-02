extends Spatial

signal select(node)

var dialog_popup = null
var waiting_calls = []
var ringing = false
var picked_up = false

func _ready():
	dialog_popup = $HandsetCo/TextPopup
	dialog_popup.visible = false
	#TODO Clear this:
	add_dialogue(["\nCeci est un premier test de dialogue!",
				"\nEt ceci est la seconde partie"])
	add_dialogue(["\nEt voici même un second appel",
				"J'espère que tout marche même lorsque les messages sont très long et pas beau"])
	
func add_dialogue(dialog: Array):
	waiting_calls.append(dialog)
	if not ringing:
		$Ringing.play("Ring")
		ringing = true

func _on_phone_pickup():
	if ringing:
		$Ringing.stop(true)
		ringing = false
		$Decrocher.play("Décrocher")
		picked_up = true
		dialog_popup.set_dialog(waiting_calls.pop_front())
	else:
		print_debug("Prof. Chen: You can't do that right now.")

func _on_phone_hang():
	$Decrocher.play("Raccrocher")
	if not waiting_calls.empty():
		$Ringing.play("Ring")
		ringing = true

func _on_Handset_mouse_entered():
	if ringing:
		emit_signal("select", $HandsetCo)

func _on_Handset_mouse_exited():
	emit_signal("select", null)
