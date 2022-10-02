extends GeneralTool

func _on_mouse_entered():
	emit_signal("select", self)
	self.animate(true)

func _on_mouse_exited():
	emit_signal("select", null)
	self.animate(false)

func animate(play: bool):
	$extincteur/CPUParticles.emitting = play
