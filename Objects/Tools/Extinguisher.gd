extends StaticBody

signal select(node)

func _on_Extinguisher_mouse_entered():
	emit_signal("select", self)

func _on_Extinguisher_mouse_exited():
	emit_signal("select", null)
