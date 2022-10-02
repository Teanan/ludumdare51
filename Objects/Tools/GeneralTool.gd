extends StaticBody

class_name GeneralTool

signal select(node)

func _on_mouse_entered():
	emit_signal("select", self)

func _on_mouse_exited():
	emit_signal("select", null)

func animate(play: bool):
	pass
