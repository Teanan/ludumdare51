extends Spatial

onready var RoomScene = $"../.."
onready var PV = $"../../PV"

export (String) var ActionTool = "Extinguisher"

var progress = 0

const MAX_PARTICULES = 20
const MIN_PARTICULES = 10

func _ready():
	if RoomScene == null:
		assert(false, "faut lancer la BoilerRoom connard")
	$ToolIcon/Tools.get_node(ActionTool).visible = true
	$ToolIcon.visible = false
	clear_event()
	
func trigger_event():
	progress = 0
	self.input_ray_pickable = true
	$Fire/CPUParticles.amount = MAX_PARTICULES
	$Fire/CPUParticles.emitting = true
	$FailTimer.start()
	$SFX.play()
	print("new fire!")

func clear_event():
	self.input_ray_pickable = false
	$ToolIcon.visible = false
	$Fire/CPUParticles.emitting = false
	$SFX.stop()
	$FailTimer.stop()
	$ActionTimer.stop()

func _on_Leak_mouse_entered():
	if $Fire/CPUParticles.emitting:
		$ToolIcon.visible = true
	$ActionTimer.start()

func _on_Leak_mouse_exited():
	$ToolIcon.visible = false
	$ActionTimer.stop()

func _on_ActionTimer_timeout():
	if RoomScene.using_tool and RoomScene.hand != null and RoomScene.hand.is_in_group(ActionTool):
		if RoomScene.hand.has_method("play_sfx"):
			RoomScene.hand.play_sfx(true)
		progress = progress + 3
		# does not work, reset particules system on updates
		#$Fire/CPUParticles.amount = MiscFunc.map(progress, 0, 100, MIN_PARTICULES, MAX_PARTICULES);
		#print("fire fixing : " + str(progress))
		if progress >= 100:
			print("fixed fire!")
			clear_event()

func _on_FailTimer_timeout():
	PV.remove_pv(1)
	print("failed fire")


func is_activated():
	return $Fire/CPUParticles.emitting
	
func is_activable(temperature, _pressure, _cur_events):
	return temperature > 0.3
	
