extends GeneralGauge

func _ready():
	MAX_ANGLE_DEG = -142.0
	MIN_ANGLE_DEG = 142.0
	$ToolIcon/Tools/PressureHandle.visible = true
	$ToolIcon.visible = false

func _on_LargeGauge_mouse_entered():
	if target_value > 75:
		$ToolIcon.visible = true

func _on_LargeGauge_mouse_exited():
	$ToolIcon.visible = false
