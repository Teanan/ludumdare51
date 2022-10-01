extends Spatial

onready var RoomScene = $"../.."
onready var FixedCable = $"../../PlafonnierElec/FixedCable"

export (String) var ActionTool = "Wrench"

var progress = 0

func _ready():
	if RoomScene == null:
		assert(false, "faut lancer la BoilerRoom connard")
	clear_event()

func trigger_event():
	FixedCable.visible = false
	$BrokenCable.visible = true
	$FailTimer.start()
	print("broken cable!")

func clear_event():
	FixedCable.visible = true
	$BrokenCable.visible = false
	$FailTimer.stop()
	$ActionTimer.stop()

func _on_BrokenCable_mouse_entered():
	print("helo")
	$ActionTimer.start()

func _on_BrokenCable_mouse_exited():
	$ActionTimer.stop()

func _on_ActionTimer_timeout():
	if RoomScene.using_tool and RoomScene.hand.is_in_group(ActionTool):
		progress = progress + 4
		print("cable fixing : " + str(progress))
		if progress >= 100:
			print("cable fixed!")
			clear_event()

func _on_FailTimer_timeout():
	print("failed")
