extends Spatial

onready var RoomScene = $"../.."
onready var FixedCable = $"../../PlafonnierElec/FixedCable"
onready var PV = $"../../PV"

export (String) var ActionTool = "Tape"

var progress = 0

func _ready():
	if RoomScene == null:
		assert(false, "faut lancer la BoilerRoom connard")
	$ToolIcon/Tools.get_node(ActionTool).visible = true
	$ToolIcon.visible = false
	clear_event()

func trigger_event():
	self.input_ray_pickable = true
	FixedCable.visible = false
	$BrokenCable.visible = true
	$FailTimer.start()
	print("broken cable!")

func clear_event():
	self.input_ray_pickable = false
	FixedCable.visible = true
	$BrokenCable.visible = false
	$ToolIcon.visible = false
	$FailTimer.stop()
	$ActionTimer.stop()

func _on_BrokenCable_mouse_entered():
	if $BrokenCable.visible:
		$ToolIcon.visible = true
	$ActionTimer.start()

func _on_BrokenCable_mouse_exited():
	$ToolIcon.visible = false
	$ActionTimer.stop()

func _on_ActionTimer_timeout():
	if RoomScene.using_tool and RoomScene.hand.is_in_group(ActionTool):
		progress = progress + 4
		print("cable fixing : " + str(progress))
		if progress >= 100:
			print("cable fixed!")
			clear_event()

func _on_FailTimer_timeout():
	PV.remove_pv(10)
	print("failed")
