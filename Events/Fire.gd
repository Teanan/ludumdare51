extends Spatial

onready var RoomScene = $"../.."
onready var PV = $"../../PV"

export (String) var ActionTool = "Extinguisher"

var progress = 0

func _ready():
	if RoomScene == null:
		assert(false, "faut lancer la BoilerRoom connard")
	$ToolIcon/Tools.get_node(ActionTool).visible = true
	$ToolIcon.visible = false
	clear_event()
	
func trigger_event():
	progress = 0
	self.input_ray_pickable = true
	$Fire.visible = true
	$Fire/CPUParticles.emitting = true
	$FailTimer.start()
	print("new fire!")

func clear_event():
	self.input_ray_pickable = false
	$Fire.visible = false
	$ToolIcon.visible = false
	$Fire/CPUParticles.emitting = false
	$FailTimer.stop()
	$ActionTimer.stop()

func _on_Leak_mouse_entered():
	if $Fire.visible:
		$ToolIcon.visible = true
	$ActionTimer.start()

func _on_Leak_mouse_exited():
	$ToolIcon.visible = false
	$ActionTimer.stop()

func _on_ActionTimer_timeout():
	if RoomScene.using_tool and RoomScene.hand.is_in_group(ActionTool):
		progress = progress + 3
		print("fire fixing : " + str(progress))
		if progress >= 100:
			print("fixed fire!")
			clear_event()

func _on_FailTimer_timeout():
	PV.remove_pv(2)
	print("failed fire")
