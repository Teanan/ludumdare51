extends StaticBody

signal select(node)

func _on_Extinguisher_mouse_entered():
	emit_signal("select", self)
	self.animate(true)

func _on_Extinguisher_mouse_exited():
	emit_signal("select", null)
	self.animate(false)

func animate(play):
	$extincteur/CPUParticles.visible = play
	
