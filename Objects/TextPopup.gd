extends Spatial

func _ready():
	set_text("Hello world")

func set_text(text):
	$Viewport/GUI/Label.text = text
