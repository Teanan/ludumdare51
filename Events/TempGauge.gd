extends Spatial

onready var RoomScene = $"../.."
onready var Gauge = $"../../Boilerco/BoilerAssembly/boiler/Gauge"
onready var particles = $"../../Boilerco/BoilerAssembly/boiler/Gauge/FireParticles/CPUParticles"

export (String) var ActionTool = "Hammer"

var progress = 0

func _ready():
	$ToolIcon/Tools.get_node(ActionTool).visible = true
	$ToolIcon.visible = false
	clear_event()
	
func trigger_event():
	progress = 0
	self.input_ray_pickable = true
	particles.emitting = true
	Gauge.BUGGED = true
	print("broken gauge!")

func clear_event():
	self.input_ray_pickable = false
	particles.emitting = false
	$ToolIcon.visible = false
	Gauge.BUGGED = false
	$ActionTimer.stop()

func _on_TempGauge_mouse_entered():
	if Gauge.BUGGED:
		$ToolIcon.visible = true
	$ActionTimer.start()

func _on_TempGauge_mouse_exited():
	$ToolIcon.visible = false
	$ActionTimer.stop()

func _on_ActionTimer_timeout():
	if RoomScene.using_tool and RoomScene.hand and RoomScene.hand.is_in_group(ActionTool):
		if RoomScene.hand.has_method("play_sfx"):
			RoomScene.hand.play_sfx(true)
		progress = progress + 2.5
		#print("gauge fixing : " + str(progress))
		if progress >= 100:
			print("fixed gauge!")
			clear_event()


func is_activated():
	return Gauge.BUGGED
	
func is_activable(_temperature, _pressure, _cur_events):
	return true
	
