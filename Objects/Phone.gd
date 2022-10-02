extends Spatial

signal select(node)
signal dialog_completed(fully)

const RING_LIMIT_BEFORE_FAIL = 5

var waiting_calls = []
var ringing = false
var picked_up = false
var nbr_rang = 0

onready var dialog_popup = $HandsetCo/TextPopup

func _ready():
	dialog_popup.visible = false
	#TODO Clear this:
#	add_dialogue(["\nCeci est un premier test de dialogue!",
#				"\nEt ceci est la seconde partie"])
#	add_dialogue(["\nEt voici même un second appel",
#				"J'espère que tout marche même lorsque les messages sont très long et pas beau"])
	
func add_dialogue(dialog: Array):
	waiting_calls.append(dialog)
	queue_next()
	
func clear_all_dialogue():
	waiting_calls.clear()
	if picked_up:
		$Decrocher.play("Raccrocher",-1 , 5.0)
		picked_up = false

func queue_next():
	if not ringing and not waiting_calls.empty():
		$Ringing.play("Ring")
		ringing = true
	
func _on_phone_pickup():
	if ringing:
		$Ringing.stop(true)
		ringing = false
		$Decrocher.play("Décrocher")
		picked_up = true
		dialog_popup.set_dialog(waiting_calls.pop_front())
		nbr_rang = 0
	else:
		print_debug("Prof. Chen: You can't do that right now.")

func _on_phone_hang():
	$Decrocher.play("Raccrocher")
	$Voice.stop()
	picked_up = false
	emit_signal("dialog_completed", dialog_popup.is_current_dialog_finished())
	if not waiting_calls.empty():
		$Ringing.play("Ring")
		ringing = true

func _on_Handset_mouse_entered():
	if ringing:
		emit_signal("select", $HandsetCo)

func _on_Handset_mouse_exited():
	emit_signal("select", null)

func _on_Ringing_animation_finished(anim_name):
	if anim_name != "Ring":
		pass
	nbr_rang += 1
	$SFX.play()
	if nbr_rang > RING_LIMIT_BEFORE_FAIL:
		print("You failed at picking up the phone")
		emit_signal("dialog_completed", false)
		ringing = false
		nbr_rang = 0
		waiting_calls.pop_front()
		queue_next()
	else:
		#print(anim_name + " : " + str(nbr_rang))
		$Ringing.play("Ring")


func _on_Decrocher_animation_finished(anim_name):
	if anim_name == "Décrocher":
		$Voice.play()
		dialog_popup.display_next()
