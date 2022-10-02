extends Spatial

export var SPEED_TEXT = 0.05 #En seconde par charactère

var curent_dialog = []
onready var label = $Viewport/GUI/Label
onready var textFade = $TextDisplay

func _ready():
	set_text("Hello world")

func set_text(text):
	label.clear()
	label.push_align(RichTextLabel.ALIGN_CENTER)
	label.visible_characters = 0
	label.add_text(text)

func set_dialog(dialog: Array):
	curent_dialog = dialog

func is_current_dialog_finished():
	return curent_dialog.empty()

func display_next():
	if not curent_dialog.empty():
		set_text(curent_dialog.pop_front())
		textFade.interpolate_property(label, "visible_characters", 0, \
			label.text.length(), label.text.length()*SPEED_TEXT)
		textFade.start()
		textFade.set_active(true)

func _on_TextPopup_input_event(_camera, _event, _position, _normal, _shape_idx):
	if Input.is_action_just_released("Action"):
		if(textFade.is_active()):
			print("Skipping!")
			textFade.stop(label, "visible_characters")
			textFade.set_active(false)
			label.visible_characters = -1
		else:
			print("Next Line!")
			display_next()
