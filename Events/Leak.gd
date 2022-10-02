extends Spatial

onready var RoomScene = $"../.."
onready var Boiler = $"../../Boilerco/BoilerAssembly"

export (String) var ActionTool = "Tape"

var progress = 0

func _ready():
	if RoomScene == null:
		assert(false, "faut lancer la BoilerRoom connard")
	$ToolIcon/Tools.get_node(ActionTool).visible = true
	$ToolIcon.visible = false
	clear_event()
	
func trigger_event():
	$Water.visible = true
	$Water/CPUParticles.emitting = true
	$FailTimer.start()
	print("new leak!")

func clear_event():
	$Water.visible = false
	$ToolIcon.visible = false
	$Water/CPUParticles.emitting = false
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
		progress = progress + 2
		print("leak fixing : " + str(progress))
		if progress >= 100:
			print("fixed!")
			clear_event()

func _on_FailTimer_timeout():
	print("failed")
