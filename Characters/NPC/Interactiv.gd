extends Polygon2D

onready var camera :Camera2D = null
var _globalData = GlobalData

func _ready():
	camera = _globalData._camera
	if camera != null:
		camera.connect("zoom_changed", self, "_on_zoom_changed")
		_on_zoom_changed()

func _on_zoom_changed():
	print("WTF")
	scale.x = camera.zoom.x * 3
	scale.y = camera.zoom.x * 3
	position.y = (scale.x - 1) * 48
