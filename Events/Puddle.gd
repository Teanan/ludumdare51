extends Spatial

onready var RoomScene = $"../.."
onready var PV = $"../../PV"
onready var Water = $Water/Water

export (String) var ActionTool = "Mop"

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
	Water.visible = true
	$RaisingWater.play("RaisingPuddle")
	$FailTimer.start()
	print("new puddle!")

func clear_event():
	self.input_ray_pickable = false
	Water.visible = false
	$ToolIcon.visible = false
	$FailTimer.stop()
	$ActionTimer.stop()

func _on_Leak_mouse_entered():
	if Water.visible:
		$ToolIcon.visible = true
	$ActionTimer.start()

func _on_Leak_mouse_exited():
	$ToolIcon.visible = false
	$ActionTimer.stop()

func _on_ActionTimer_timeout():
	if RoomScene.using_tool and RoomScene.hand.is_in_group(ActionTool):
		if RoomScene.hand.has_method("play_sfx"):
			RoomScene.hand.play_sfx(true)
		progress = progress + 2.5
		#print("puddle fixing : " + str(progress))
		$Water.set_translation(Vector3(0, -0.09, 0) * (min(progress, 100.0) / 100.0))
		if progress >= 100:
			print("fixed puddle!")
			clear_event()

func _on_FailTimer_timeout():
	PV.remove_pv(1)
	print("failed puddle")


func is_activated():
	return Water.visible
	
func is_activable(_temperature, _pressure, _cur_events):
	return true
	
