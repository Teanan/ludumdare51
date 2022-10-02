extends Spatial

export (int) var pv = 100 setget set_pv

onready var Alarm = $"../Alarm"

func _ready():
	set_pv(100)

func set_pv(_pv):
	pv = _pv
	$Viewport/GUI/ProgressBar.value = pv

func add_pv(qte):
	set_pv(pv + qte)
	if pv > 25:
		Alarm.stop_alarm()
	if pv > 100:
		set_pv(100)

func remove_pv(qte):
	set_pv(pv - qte)
	if pv <= 25:
		Alarm.start_alarm()
	if pv < 0:
		set_pv(0)
		# TODO trigger game over
