extends StaticBody

signal select(node)

func _on_Tape_mouse_entered():
	emit_signal("select", self)

func _on_Tape_mouse_exited():
	emit_signal("select", null)
