extends Sprite

onready var selected = $selected
onready var timer = $Timer
onready var UI = get_tree().current_scene.get_node("Fade")

export var anim_speed = 4
export var anim_end = 12

export var change_to = "" #will change scene to this var
export var set_position_to = Vector2.ZERO

var opening :bool#is opening door?
var player_on_area :bool
var start_frame :int
var player :KinematicBody2D
var playerStats = PlayerStats

func _ready():
	start_frame = frame
	UI.connect("FadeInFinished", self, "_on_FadeInFinished")
	set_active(false)

#Click to E key
func _unhandled_input(_event):
	if player_on_area and Input.is_action_just_released("action"):
		UI.start_anim("FadeIn")

#Animation for opening door
func _on_Timer_timeout():
	if opening:
		if frame == start_frame+anim_end:
			timer.stop()
		else:
			frame += anim_speed
	else:
		if frame == start_frame:
			timer.stop()
		else:
			frame -= anim_speed

#Changind scene when Faded animashion finished
func _on_FadeInFinished():
	playerStats.spawnPosition = set_position_to
# warning-ignore:return_value_discarded
	get_tree().change_scene(change_to)

#Player Entered and Exited
func _on_Area2D_body_entered(_body):
	player = _body
	set_active(true)

func _on_Area2D_body_exited(_body):
	player = null
	set_active(false)

func set_active(_bool):
	opening = _bool
#	selected.visible = _bool
#	selected.playing = _bool
	player_on_area = _bool
	if timer.is_inside_tree():
		timer.start()
