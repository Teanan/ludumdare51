extends Spatial

onready var RoomScene = $"../.."
onready var PV = $"../../PV"

export (String) var ActionTool = "Mop"

var progress = 0

func _ready():
	if RoomScene == null:
		assert(false, "faut lancer la BoilerRoom connard")
	$ToolIcon/Tools.get_node(ActionTool).visible = true
	$ToolIcon.visible = false
	clear_event()
	
func trigger_event():
	self.input_ray_pickable = true
	$Water.visible = true
	$FailTimer.start()
	print("new puddle!")

func clear_event():
	self.input_ray_pickable = false
	$Water.visible = false
	$ToolIcon.visible = false
	$FailTimer.stop()
	$ActionTimer.stop()

func _on_Leak_mouse_entered():
	if $Water.visible:
		$ToolIcon.visible = true
	$ActionTimer.start()

func _on_Leak_mouse_exited():
	$ToolIcon.visible = false
	$ActionTimer.stop()

func _on_ActionTimer_timeout():
	if RoomScene.using_tool and RoomScene.hand.is_in_group(ActionTool):
		progress = progress + 2.5
		print("puddle fixing : " + str(progress))
		if progress >= 100:
			print("fixed puddle!")
			clear_event()

func _on_FailTimer_timeout():
	PV.remove_pv(2)
	print("failed puddle")
