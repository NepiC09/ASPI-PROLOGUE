extends Camera2D

onready var topLeft = $Limits/TopLeft
onready var bottomRight = $Limits/BottomRight
onready var _globalData = GlobalData

export var max_zoom = 1.5
export var min_zoom = 0.5

signal zoom_changed

func _ready():
	limit_left = topLeft.position.x
	limit_top = topLeft.position.y
	limit_right = bottomRight.position.x
	limit_bottom = bottomRight.position.y
	zoom.x = clamp(_globalData._cameraZoom.x, min_zoom, max_zoom)
	zoom.y = clamp(_globalData._cameraZoom.y, min_zoom, max_zoom)
	_globalData._camera = self
	emit_signal("zoom_changed")

func _exit_tree():
	_globalData._cameraZoom = zoom
	_globalData._camera = null

func _unhandled_input(_event):
	if Input.is_action_just_released("scroll_down") and !zoom_max():
		zoom.x += 0.1
		zoom.y += 0.1
		emit_signal("zoom_changed")
		
	if Input.is_action_just_released("scroll_up") and !zoom_min():
		zoom.x -= 0.1
		zoom.y -= 0.1
		emit_signal("zoom_changed")

func zoom_max():
	if zoom.x >= max_zoom and zoom.y >= max_zoom:
		return 1
	else:
		return 0

func zoom_min():
	if zoom.x <= min_zoom and zoom.y <= min_zoom:
		return 1
	else:
		return 0
