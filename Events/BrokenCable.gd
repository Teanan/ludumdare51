extends Spatial

onready var RoomScene = $"../.."
onready var FixedCable = $"../../PlafonnierElec/FixedCable"
onready var light_plafonnier = $"../../PlafonnierElec/LightPlafonnier"
onready var PV = $"../../PV"
onready var spark_particles = $SparkParticles/CPUParticles

export (String) var ActionTool = "Tape"

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
	FixedCable.visible = false
	$BrokenCable.visible = true
	light_plafonnier.turn_off()
	spark_particles.emitting = true
	$SFX.play()
	$FailTimer.start()
	print("broken cable!")

func clear_event():
	self.input_ray_pickable = false
	FixedCable.visible = true
	$BrokenCable.visible = false
	light_plafonnier.turn_on()
	spark_particles.emitting = false
	$ToolIcon.visible = false
	$SFX.stop()
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
		if RoomScene.hand.has_method("play_sfx"):
			RoomScene.hand.play_sfx(true)
		progress = progress + 4
		print("cable fixing : " + str(progress))
		if progress >= 100:
			print("cable fixed!")
			clear_event()

func _on_FailTimer_timeout():
	PV.remove_pv(1)
	#print("failed broken cable")
