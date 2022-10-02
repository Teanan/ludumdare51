extends Spatial

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
	display_next()

func display_next():
	if not curent_dialog.empty():
		set_text(curent_dialog.pop_front())
		textFade.interpolate_property(label, "visible_characters", 0, \
			label.text.length(), label.text.length()*0.05)
		textFade.start()
		textFade.set_active(true)


func _on_TextPopup_input_event(camera, event, position, normal, shape_idx):
	if Input.is_action_just_released("Action"):
		if(textFade.is_active()):
			print_debug("Skipping!")
			textFade.stop(label, "visible_characters")
			textFade.set_active(false)
			label.visible_characters = -1
		else:
			print_debug("Next Line!")
			display_next()
