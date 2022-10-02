extends Spatial

onready var RoomScene = $"../.."
onready var Gauge = $"../../Boilerco/LargeGauge"

export (String) var ActionTool = "Hammer"

var progress = 0

func _ready():
	$ToolIcon/Tools.get_node(ActionTool).visible = true
	$ToolIcon.visible = false
	clear_event()
	
func trigger_event():
	progress = 0
	self.input_ray_pickable = true
	Gauge.BUGGED = true
	print("broken gauge!")

func clear_event():
	self.input_ray_pickable = false
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
	if RoomScene.using_tool and RoomScene.hand.is_in_group(ActionTool):
		progress = progress + 2.5
		print("gauge fixing : " + str(progress))
		if progress >= 100:
			print("fixed gauge!")
			clear_event()
